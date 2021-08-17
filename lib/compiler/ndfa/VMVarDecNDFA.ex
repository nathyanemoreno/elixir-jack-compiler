defmodule VMVarDecNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "type" => nil,
          "varNames" => []
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
        IO.puts("Checking token in VarDec")

        cond do
          # * If keyword var get next
          tokenType == :keyword and token == "var" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            IO.puts(">> Exiting VarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        type = VMTypeNDFA.checkToken(stream, index)

        case type["finished"] do
          true ->
            mModel = Map.replace(mModel, "type", type["object"]["name"])
            checkToken(stream, type["index"], mModel, 2)

          false ->
            IO.puts(">> Exiting VarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        cond do
          # * Read again
          varName["finished"] == true ->
            mModel =
              Map.replace(
                mModel,
                "varNames",
                mModel["varNames"] ++ [varName["object"]["name"]]
              )

            checkToken(stream, varName["index"], mModel, 3)

          true ->
            IO.puts(">> Exiting VarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        IO.puts("Checking token in VarDec")

        cond do
          # * If keyword var get next
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, mModel, 4)

          true ->
            checkToken(stream, index, mModel, 5)
        end

      4 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        cond do
          # * Read again
          varName["finished"] == true ->
            mModel =
              Map.replace(
                mModel,
                "varNames",
                mModel["varNames"] ++ [varName["object"]["name"]]
              )

            checkToken(stream, varName["index"], mModel, 3)

          true ->
            checkToken(stream, index, mModel, 5)
        end

      5 ->
        cond do
          # * If keyword var get next
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting VarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting VarDecNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
