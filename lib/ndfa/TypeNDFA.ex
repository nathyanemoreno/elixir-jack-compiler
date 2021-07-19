defmodule TypeNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    IO.inspect("Checking token in Type " <> "--------------------> " <> tokenObj["token"])

    case state do
      # Read: keyword
      0 ->
        className = ClassNameNDFA.checkToken(stream, index)

        cond do
          tokenType == :keyword and token == "int" ->
            checkToken(stream, nextIndex, 1)

          tokenType == :keyword and token == "char" ->
            checkToken(stream, nextIndex, 1)

          tokenType == :keyword and token == "boolean" ->
            checkToken(stream, nextIndex, 1)

          className["finished"] == true ->
            checkToken(stream, className["index"], 1)

          true ->
            %{"finished" => true, "index" => index, "token" => token}
        end

      1 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
