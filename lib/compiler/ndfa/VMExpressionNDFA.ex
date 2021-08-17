defmodule VMExpressionNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "expression" => []
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.puts("Checking token Expression")
        term = VMTermNDFA.checkToken(stream, index)

        cond do
          term["finished"] ->
            mModel = Map.replace(mModel, "expression", [term["object"]])
            checkToken(stream, term["index"], mModel, 1)

          true ->
            IO.puts(">> Exiting ExpressionNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        op = VMOperatorNDFA.checkToken(stream, index)

        cond do
          op["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "expression",
                mModel["expression"] ++ [op["object"]]
              )

            checkToken(stream, op["index"], mModel, 2)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      2 ->
        term = VMTermNDFA.checkToken(stream, index)

        cond do
          term["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "expression",
                mModel["expression"] ++ [term["object"]]
              )

            checkToken(stream, term["index"], mModel, 1)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      100 ->
        IO.puts(">> Exiting ExpressionNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
