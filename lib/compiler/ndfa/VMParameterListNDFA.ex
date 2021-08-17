defmodule VMParameterListNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "_type" => nil,
          "parameters" => []
        },
        state \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case state do
      0 ->
        IO.inspect("Checking token in ParameterList ")
        type = VMTypeNDFA.checkToken(stream, index)

        cond do
          type["finished"] ->
            mModel = Map.replace(mModel, "_type", type["object"]["name"])
            checkToken(stream, type["index"], mModel, 1)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      1 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        cond do
          varName["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "parameters",
                mModel["parameters"] ++
                  [%{"type" => mModel["_type"], "varName" => varName["object"]["name"]}]
              )

            checkToken(stream, varName["index"], mModel, 2)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      2 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, mModel, 3)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      3 ->
        type = VMTypeNDFA.checkToken(stream, index)

        cond do
          type["finished"] ->
            mModel = Map.replace(mModel, "_type", type["object"]["name"])
            checkToken(stream, type["index"], mModel, 4)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      4 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        cond do
          varName["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "parameters",
                mModel["parameters"] ++
                  [%{"type" => mModel["_type"], "varName" => varName["object"]["name"]}]
              )

            checkToken(stream, varName["index"], mModel, 2)

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
