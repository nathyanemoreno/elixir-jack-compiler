defmodule WhileStatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.puts("Checking token WhileStatementNDFA")
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "while" -> checkToken(stream, "<keyword> while </keyword>", nextIndex, 1)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            # * If find ( look for expression
            checkToken(stream, xml_carry <> "\n<symbol> ( </symbol>", nextIndex, 2)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      2 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)
        
        cond do
          expression["finished"] ->
            checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 3)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, xml_carry <> "\n<symbol> ) </symbol>", nextIndex, 4)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      4 ->
        cond do
          tokenType == :symbol and token == "{" ->
            # * If find ( look for expression
            checkToken(stream, xml_carry <> "\n<symbol> { </symbol>", nextIndex, 5)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      5 ->
        statements = StatementsNDFA.checkToken(stream, "", index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
          true ->
            checkToken(stream, xml_carry <> "\n" <> statements["xml"], statements["index"], 6)
        end

      6 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, xml_carry <> "\n<symbol> } </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      
      100 ->
        IO.puts(">> Exiting WhileStatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<whileStatement>\n" <> xml_carry <> "\n</whileStatement>"}
    end
  end
end
