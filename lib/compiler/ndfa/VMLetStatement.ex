defmodule VMLetStatementNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "varName" => nil,
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
        IO.inspect("Checking token LetStatement")

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "let" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        varName = VMVarNameNDFA.checkToken(stream, index)

        cond do
          varName["finished"] ->
            mModel = Map.replace(mModel, "varName", varName["object"]["name"])
            checkToken(stream, varName["index"], mModel, 2)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        cond do
          tokenType == :symbol and token == "[" -> checkToken(stream, nextIndex, mModel, 3)
          true -> checkToken(stream, index, mModel, 10)
        end

      3 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            mModel = Map.replace(mModel, "expression", expression["object"]["expression"])
            checkToken(stream, expression["index"], mModel,  4)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      4 ->
        cond do
          tokenType == :symbol and token == "]" ->
            checkToken(stream, nextIndex, mModel, 10)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      10 ->
        cond do
          tokenType == :symbol and token == "=" ->
            checkToken(stream, nextIndex, mModel, 11)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      11 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            mModel = Map.replace(mModel, "expression", expression["object"]["expression"])
            checkToken(stream, expression["index"], mModel, 12)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      12 ->
        cond do
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting LetStatementNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
