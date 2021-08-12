defmodule SubroutineBodyNDFA do
  def checkToken(stream, index, state \\ 0) do
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
            checkToken(stream, nextIndex, 1)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        varDec = VarDecNDFA.checkToken(stream, index)

        cond do
          varDec["finished"] ->
            checkToken(stream, varDec["index"], 1)
          true ->
            checkToken(stream, index, 2)
        end

      2 ->
        statementsNDFA = StatementsNDFA.checkToken(stream, index)
        cond do
          statementsNDFA["finished"] -> checkToken(stream, statementsNDFA["index"], 3)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          tokenType == :symbol and token == "}" -> checkToken(stream, nextIndex, 100)
          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        IO.puts(">> Exiting SubroutineBodyNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
