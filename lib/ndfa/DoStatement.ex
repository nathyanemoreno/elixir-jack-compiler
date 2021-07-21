defmodule DoStatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect("Checking token DoStatementNDFA")
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "do" -> checkToken(stream, "<keyword> do </keyword>", nextIndex, 1)
          true ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      1 ->
        subroutineCall = SubroutineCallNDFA.checkToken(stream, "", index)

        case subroutineCall["finished"] do
          true -> checkToken(stream, xml_carry <> "\n" <> subroutineCall["xml"], subroutineCall["index"], 2)
          false ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, xml_carry <> "\n<symbol> ; </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      100 ->
        IO.puts(">> Exiting DoStatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<doStatement>\n" <> xml_carry <> "\n</doStatement>"}
    end
  end
end