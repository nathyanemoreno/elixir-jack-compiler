defmodule VMClassVarDecNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "kind" => nil,
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
      # * Read: keyword
      0 ->
        IO.inspect("Checking token in ClassVarDec")

        cond do
          # * If token is "field" or "static" got to state 1
          tokenType == :keyword and (token == "field" or token == "static") ->
            mModel = Map.replace(mModel, "kind", token)
            checkToken(stream, nextIndex, mModel, 1)

          # * Go to nil to go to subroutine
          true ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      # * Read: type
      1 ->
        type = VMTypeNDFA.checkToken(stream, index)

        case type["finished"] do
          false ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}

          true ->
            mModel = Map.replace(mModel, "type", token)
            checkToken(stream, type["index"], mModel, 2)
        end

      # * Read: varName
      2 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        case varName["finished"] do
          false ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}

          true ->
            mModel = Map.replace(mModel, "varNames", mModel["varNames"] ++ [varName["object"]["name"]])
            checkToken(stream, varName["index"], mModel, 3)
        end

      3 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, mModel, 2)

          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting ClassVarDecNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
