defmodule ClassVarDecNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    #

    case state do
      # * Read: keyword
      0 ->


        cond do
          # * If token is "field" or "static" got to state 1
          tokenType == :keyword and (token == "field" or token == "static") ->
            checkToken(stream, nextIndex, 1)

          # * Go to nil to go to subroutine
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      # * Read: type
      1 ->
        type = TypeNDFA.checkToken(stream, index)

        case type["finished"] do
          false ->

            %{"finished" => false, "index" => index, "token" => token}

          true ->
            checkToken(stream, type["index"], 2)
        end

      # * Read: varName
      2 ->
        varName = VarNameNDFA.checkToken(stream, index)

        case varName["finished"] do
          false ->

            %{"finished" => false, "index" => index, "token" => token}

          true ->
            checkToken(stream, varName["index"], 3)
        end

      3 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 4)

          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, 100)

          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      4 ->
        varName = VarNameNDFA.checkToken(stream, index)
        checkToken(stream, varName["index"], 3)

      100 ->


        %{
          "finished" => true,
          "index" => index,
          "token" => token,

        }
    end
  end
end
