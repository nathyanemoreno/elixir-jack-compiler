defmodule VarDecNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    #

    case state do
      0 ->

        cond do
          # * If keyword var get next
          tokenType == :keyword and token == "var" ->
            checkToken(stream, nextIndex, 1)

          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        type = TypeNDFA.checkToken(stream, index)

        case type["finished"] do
          true -> checkToken(stream, type["index"], 2)
          false ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      2 ->
        varName = VarNameNDFA.checkToken(stream, index)

        cond do
          # * Read again
          varName["finished"] == true ->
            checkToken(stream, varName["index"], 3)
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->

        cond do
          # * If keyword var get next
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 4)

          true -> checkToken(stream, index, 5)
        end
      4 ->
        varName = VarNameNDFA.checkToken(stream, index)

        cond do
          # * Read again
          varName["finished"] == true ->
            checkToken(stream, varName["index"], 3)
          true -> checkToken(stream, index, 5)
        end
      5 ->
        cond do
          # * If keyword var get next
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, 100)
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
