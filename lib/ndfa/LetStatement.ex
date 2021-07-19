defmodule LetStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token LetStatement " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "let" -> checkToken(stream, nextIndex, 1)
          true -> checkToken(stream, index, nil)
        end

      1 ->
        varName = VarNameNDFA.checkToken(stream, index)

        case varName["finished"] do
          false ->
            checkToken(stream, varName["index"], nil)

          true ->
            checkToken(stream, nextIndex, 2)
        end

      2 ->
        case tokenType do
          :symbol ->
            case token do
              # * Read expression and go to 100
              "[" ->
                checkToken(stream, nextIndex, 3)

              "=" ->
                checkToken(stream, nextIndex, 4)

              # * Case find only Varname go to 2 again look for =
              true ->
                checkToken(stream, nextIndex, 2)
            end
        end

      3 ->
        expression = Expression.checkToken(stream, index)

        case expression["finished"] do
          false ->
            checkToken(stream, expression["index"], nil)

          true ->
            checkToken(stream, expression["index"], 5)
        end

      4 ->
        expression = Expression.checkToken(stream, index)

        case expression["finished"] do
          false ->
            checkToken(stream, expression["index"], nil)

          true ->
            checkToken(stream, expression["index"], 6)
        end

      5 ->
        cond do
          tokenType == :symbol and token == "]" ->
            # * If find ] look for = in state 2
            checkToken(stream, nextIndex, 2)

          true ->
            checkToken(stream, index, nil)
        end

      6 ->
        cond do
          # * Case is ; read go to 100
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, 0)

          true ->
            checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
