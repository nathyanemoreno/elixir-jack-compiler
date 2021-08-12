defmodule ExpressionNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]


    case tokenState do
      0 ->

        term = TermNDFA.checkToken(stream, index)
        cond do
          term["finished"] -> checkToken(stream,term["index"], 1)
          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        op = OperatorNDFA.checkToken(stream, index)
        cond do
          op["finished"] -> checkToken(stream, op["index"], 2)
          true -> checkToken(stream, index, 100)
        end
      2 ->
        term = TermNDFA.checkToken(stream, index)
        cond do
          term["finished"] -> checkToken(stream, term["index"], 1)
          true -> checkToken(stream, index, 100)
        end
      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
