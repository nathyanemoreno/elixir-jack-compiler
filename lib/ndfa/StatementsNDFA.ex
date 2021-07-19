defmodule StatementsNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token Statement " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        # * Go to state 100
        returnStatement = ReturnStatementNDFA.checkToken(stream, index)

        case returnStatement["finished"] do
          false -> IO.puts("Syntax error")
          true -> checkToken(stream, returnStatement["index"], 2)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
