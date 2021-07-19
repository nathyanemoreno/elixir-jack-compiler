defmodule ReturnStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token ReturnStatement " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "return" -> checkToken(stream, nextIndex, 1)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        expression = ExpressionNDFA.checkToken(stream, index)
        cond do
          # * Go to state 1
          expression["finished"] -> checkToken(stream, expression["index"], 2)
          true -> checkToken(stream, nextIndex, 2)
        end
      
      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
