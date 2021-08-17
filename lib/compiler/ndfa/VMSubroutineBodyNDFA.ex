defmodule VMSubroutineBodyNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "varDecs" => [],
          "statments" => []
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
        IO.inspect("Checking token in SubroutineBody ")

        cond do
          tokenType == :symbol and token == "{" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        varDec = VMVarDecNDFA.checkToken(stream, index)

        cond do
          varDec["finished"] ->
            mModel = Map.replace(mModel, "varDecs", mModel["varDecs"] ++ [varDec["object"]])
            checkToken(stream, varDec["index"], mModel, 1)

          true ->
            checkToken(stream, index, mModel, 2)
        end

      2 ->
        statementsNDFA = VMStatementsNDFA.checkToken(stream, index)

        cond do
          statementsNDFA["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "statments",
                mModel["statments"] ++ statementsNDFA["object"]["statments"]
              )

            checkToken(
              stream,
              statementsNDFA["index"],
              mModel,
              3
            )

          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting SubroutineBodyNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting SubroutineBodyNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
