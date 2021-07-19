defmodule DoStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token Statement " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "do" -> checkToken(stream, index, 1)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        subroutineCall = SubroutineCallNDFA.checkToken(stream, nextIndex);

        cond do
          # * Go to state 1
          subroutineCall["finished"] -> checkToken(stream, subroutineCall["index"], 2)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, index, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 -> %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
