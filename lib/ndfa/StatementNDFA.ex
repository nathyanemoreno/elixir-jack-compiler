defmodule StatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]


    case tokenState do
      0 ->

        letStatement = LetStatementNDFA.checkToken(stream, index)

        cond do
          letStatement["finished"] -> checkToken(stream,letStatement["index"], 100)
          true ->
            ifStatement = IfStatementNDFA.checkToken(stream, index)
            cond do
              ifStatement["finished"] -> checkToken(stream,ifStatement["index"], 100)
              true ->
                whileStatement = WhileStatementNDFA.checkToken(stream, index)
                cond do
                  whileStatement["finished"] -> checkToken(stream,whileStatement["index"], 100)
                  true ->
                    doStatment = DoStatementNDFA.checkToken(stream, index)
                    cond do
                      doStatment["finished"] -> checkToken(stream,doStatment["index"], 100)
                      true ->
                        returnStatement = ReturnStatementNDFA.checkToken(stream, index)
                        cond do
                          returnStatement["finished"] -> checkToken(stream,returnStatement["index"], 100)
                          true ->

                            %{"finished" => false, "index" => index, "token" => token}
                        end
                    end
                end
            end
        end
      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
