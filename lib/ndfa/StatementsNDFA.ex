defmodule StatementsNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    # tokenType = tokenObj["type"]
    # nextIndex = tokenObj["index"]

    case tokenState do
      0 ->

        # * Go to state 100
        statement = StatementNDFA.checkToken(stream, index)

        cond do
          statement["finished"] -> checkToken(stream, statement["index"], 0)
          true -> checkToken(stream, statement["index"], 100)
        end

      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
