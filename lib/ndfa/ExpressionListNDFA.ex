defmodule ExpressionListNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            checkToken(stream, expression["index"], 1)

          true ->
            checkToken(stream, index, 100)
        end

      1 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 2)

          true ->
            checkToken(stream, index, 100)
        end

      2 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            checkToken(stream, expression["index"], 1)

          true ->
            checkToken(stream, index, 100)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
