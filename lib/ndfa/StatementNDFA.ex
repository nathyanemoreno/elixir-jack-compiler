defmodule StatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect("Checking token Statement")
        letStatement = LetStatementNDFA.checkToken(stream, "", index)
        
        cond do
          letStatement["finished"] -> checkToken(stream, letStatement["xml"], letStatement["index"], 100)
          true ->
            ifStatement = IfStatementNDFA.checkToken(stream, "", index)
            cond do
              ifStatement["finished"] -> checkToken(stream, ifStatement["xml"], ifStatement["index"], 100)
              true -> 
                whileStatement = WhileStatementNDFA.checkToken(stream, "", index)
                cond do
                  whileStatement["finished"] -> checkToken(stream, whileStatement["xml"], whileStatement["index"], 100)
                  true -> 
                    doStatment = DoStatementNDFA.checkToken(stream, "", index)
                    cond do
                      doStatment["finished"] -> checkToken(stream, doStatment["xml"], doStatment["index"], 100)
                      true -> 
                        returnStatement = ReturnStatementNDFA.checkToken(stream, "", index)
                        cond do
                          returnStatement["finished"] -> checkToken(stream, returnStatement["xml"], returnStatement["index"], 100)
                          true ->
                            IO.puts(">> Exiting StatementNDFA (FAILED)")
                            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
                        end
                    end
                end
            end
        end
      100 ->
        IO.puts(">> Exiting StatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}
    end
  end
end
