defmodule DoStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]


    case tokenState do
      0 ->

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "do" -> checkToken(stream, nextIndex, 1)
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        subroutineCall = SubroutineCallNDFA.checkToken(stream, index)

        case subroutineCall["finished"] do
          true -> checkToken(stream, subroutineCall["index"], 2)
          false ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, nextIndex, 100)
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
