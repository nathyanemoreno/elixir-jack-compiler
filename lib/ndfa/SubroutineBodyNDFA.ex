defmodule SubroutineBodyNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case state do
      0 ->
        IO.inspect("Checking token in SubroutineBody ")
        cond do
          tokenType == :symbol and token == "{" ->
            checkToken(stream, "<symbol> { </symbol>", nextIndex, 1)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        varDec = VarDecNDFA.checkToken(stream, "", index)

        cond do
          varDec["finished"] ->
            checkToken(stream, xml_carry , varDec["index"], 1)
          true ->
            checkToken(stream, xml_carry, index, 2)
        end

      2 ->
        statementsNDFA = StatementsNDFA.checkToken(stream, "", index)
        cond do
          statementsNDFA["finished"] -> checkToken(stream, xml_carry , statementsNDFA["index"], 3)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          tokenType == :symbol and token == "}" -> checkToken(stream, xml_carry <> "\n<symbol> } </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        IO.puts(">> Exiting SubroutineBodyNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<subroutineBody>\n" <> xml_carry <> "\n</subroutineBody>"}
    end
  end
end
