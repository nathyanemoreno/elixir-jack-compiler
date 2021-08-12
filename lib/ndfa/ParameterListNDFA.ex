defmodule ParameterListNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    #

    case state do
      0 ->

        type = TypeNDFA.checkToken(stream, index)
        cond do
          type["finished"] -> checkToken(stream, type["index"], 1)
          true ->
            checkToken(stream, index, 100)
        end
      1 ->
        varName = VarNameNDFA.checkToken(stream, index)
        cond do
          varName["finished"] -> checkToken(stream, varName["index"], 2)
          true ->
            checkToken(stream, index, 100)
        end
      2 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 3)
          true -> checkToken(stream, index, 100)
        end
      3 ->
        type = TypeNDFA.checkToken(stream, index)
        cond do
          type["finished"] -> checkToken(stream, type["index"], 4)
          true ->
            checkToken(stream, index, 100)
        end
      4 ->
        varName = VarNameNDFA.checkToken(stream, index)
        cond do
          varName["finished"] -> checkToken(stream, varName["index"], 2)
          true ->
            checkToken(stream, index, 100)
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
