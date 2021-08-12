defmodule TypeNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case state do
      # Read: keyword
      0 ->


        cond do
          tokenType == :keyword and token == "int" ->
            checkToken(stream, nextIndex, 100)

          tokenType == :keyword and token == "char" ->
            checkToken(stream, nextIndex, 100)

          tokenType == :keyword and token == "boolean" ->
            checkToken(stream, nextIndex, 100)

          true ->
            className = ClassNameNDFA.checkToken(stream, index)

            cond do
              className["finished"] ->
                checkToken(stream, className["index"], 100)
              true ->

                %{"finished" => false, "index" => index, "token" => token}
            end
        end

      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
