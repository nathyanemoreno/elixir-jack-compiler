defmodule SubroutineCallNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token SubroutineCall " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        subroutineName = SubroutineNameNDFA.checkToken(stream, index);
        cond do
          subroutineName["finished"] -> checkToken(stream, subroutineName["index"], 1)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        cond do
          tokenType == :symbol and token == "(" -> checkToken(stream, nextIndex, 2)
          tokenType == :symbol and token == "." -> checkToken(stream, nextIndex, 10)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      2 ->
        expressionList = ExpressionListNDFA.checkToken(stream, index)
        cond do
          expressionList["finished"] -> checkToken(stream, expressionList["index"], 3)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      10 ->
        subroutineName = SubroutineNameNDFA.checkToken(stream, index)
        cond do
          subroutineName["finished"] -> checkToken(stream, subroutineName["index"], 11)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      11 ->
        cond do
          tokenType == :symbol and token == "(" -> checkToken(stream, nextIndex, 12)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      12 ->
        expressionList = ExpressionListNDFA.checkToken(stream, index)
        cond do
          expressionList["finished"] -> checkToken(stream, expressionList["index"], 13)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      13 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end