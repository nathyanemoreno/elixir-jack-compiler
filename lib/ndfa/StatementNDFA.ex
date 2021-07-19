defmodule StatementNDFA do
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
        letStatement = LetStatementNDFA.checkToken(stream, index)
        ifStatement = IfStatementNDFA.checkToken(stream, index)
        # whileStatement = WhileStatementNDFA.checkToken(stream, index)
        # doStatment = DoStatementNDFA.checkToken(stream, index)
        # returnStatement = ReturnStatementNDFA.checkToken(stream, index)
        
        cond do
          letStatement["finished"] -> checkToken(stream, letStatement["index"], 100)
          ifStatement["finished"] -> checkToken(stream, ifStatement["index"], 100)
          # whileStatement["finished"] -> checkToken(stream, whileStatement["index"], 100)
          # doStatment["finished"] -> checkToken(stream, doStatment["index"], 100)
          # returnStatement["finished"] -> checkToken(stream, returnStatement["index"], 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
