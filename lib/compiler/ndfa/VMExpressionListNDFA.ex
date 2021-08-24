defmodule VMExpressionListNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "expressions" => []
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token ExpressionListNDFA")
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            mModel = Map.replace(mModel, "expressions", [expression["object"]["expression"]])
            checkToken(stream, expression["index"], mModel, 1)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      1 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, mModel, 2)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      2 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "expressions",
                mModel["expressions"] ++ [expression["object"]["expression"]]
              )

            checkToken(stream, expression["index"], mModel, 1)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      100 ->
        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
