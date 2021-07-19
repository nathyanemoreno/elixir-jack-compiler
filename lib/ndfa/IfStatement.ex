defmodule IfStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token IfStatement " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "if" -> checkToken(stream, nextIndex, 1)
          true -> checkToken(stream, index, nil)
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, 2)

          true ->
            checkToken(stream, index, nil)
        end

      2 ->
        expression = Expression.checkToken(stream, nextIndex)

        case expression["finished"] do
          false ->
            checkToken(stream, expression["index"], nil)

          true ->
            checkToken(stream, expression["index"], 3)
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" ->
            # * If find ] look for = in state 2
            checkToken(stream, nextIndex, 4)

          true ->
            checkToken(stream, index, nil)
        end

      4 ->
        cond do
          tokenType == :symbol and token == "{" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, 5)

          true ->
            checkToken(stream, index, nil)
        end

      5 ->
        statements = Expression.checkToken(stream, nextIndex)

        case statements["finished"] do
          false ->
            checkToken(stream, statements["index"], nil)

          true ->
            checkToken(stream, statements["index"], 6)
        end

      6 ->
        cond do
          tokenType == :symbol and token == "}" ->
            # * If find ] look for = in state 2
            checkToken(stream, nextIndex, 7)

          true ->
            checkToken(stream, index, nil)
        end

      7 ->
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "else" -> checkToken(stream, nextIndex, 4)
          true -> checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
