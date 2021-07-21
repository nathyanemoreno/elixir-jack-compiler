defmodule ReturnStatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect("Checking token ReturnStatement")
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "return" -> checkToken(stream, "<keyword> return </keyword>", nextIndex, 1)
          true ->
            IO.puts(">> Exiting ReturnStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      1 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)
        checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 2)
      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, xml_carry <> "\n<symbol> ; </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting ReturnStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      100 ->
        IO.puts(">> Exiting ReturnStatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<returnStatement>\n" <> xml_carry <> "\n</returnStatement>"}
    end
  end
end
