defmodule VMReturnStatementNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "expression" => nil
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token ReturnStatement")

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "return" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            IO.puts(">> Exiting ReturnStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        case expression["finished"] do
          true ->
            mModel = Map.replace(mModel, "expression", expression["object"]["expression"])
            checkToken(stream, expression["index"], mModel, 2)

          false ->
            checkToken(stream, expression["index"], mModel, 2)
        end

      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting ReturnStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting ReturnStatementNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
