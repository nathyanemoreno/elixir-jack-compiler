defmodule LetStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token LetStatement " <>
          "--------------------> " <>
          tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "let" -> checkToken(stream, nextIndex, 1)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        varName = VarNameNDFA.checkToken(stream, index)

        cond do
          varName["finished"] ->
            checkToken(stream, varName["index"], 2)
          true ->
            %{"finished" => false, "index" => index, "token" => token}
        end

      2 ->
        cond do
          tokenType == :symbol and token == "[" -> checkToken(stream, nextIndex, 3)
          true -> checkToken(stream, index, 10)
        end

      3 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] -> checkToken(stream, expression["index"], 4)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      4 ->
        cond do
          tokenType == :symbol and token == "]" -> checkToken(stream, nextIndex, 10)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      10 ->
        cond do
          tokenType == :symbol and token == "=" -> checkToken(stream, nextIndex, 11)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      11 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] -> checkToken(stream, expression["index"], 12)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      12 ->
        cond do
          tokenType == :symbol and token == ";" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
