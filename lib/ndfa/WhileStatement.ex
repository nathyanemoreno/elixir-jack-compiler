defmodule WhileStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token WhileStatementNDFA " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "while" -> checkToken(stream, index, 1)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        cond do
          # * Go to state 2
          tokenType == :symbol and token == "(" -> checkToken(stream, index, 2)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      2 ->
        cond do
          # * Go to state 3
          tokenType == :symbol and token == "{" -> checkToken(stream, index, 3)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          # * Go to state 4
          tokenType == :symbol and token == ")" -> checkToken(stream, index, 4)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      4 ->
        cond do
          # * Go to state 5
          tokenType == :symbol and token == "{" -> checkToken(stream, index, 5)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      5 ->
        cond do
          # * Go to state 6
          tokenType == :symbol and token == ")" -> checkToken(stream, index, 6)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      6 ->
        statments = StatementsNDFA.checkToken(stream, index, 1);
        
        cond do
          # * Go to state 100
          statments["finished"] -> checkToken(stream, statments["index"])
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 -> %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
