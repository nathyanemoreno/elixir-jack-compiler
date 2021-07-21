defmodule LetStatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    
    case tokenState do
      0 ->
        IO.inspect("Checking token LetStatement")
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "let" -> checkToken(stream, "<keyword> let </keyword>", nextIndex, 1)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      1 ->
        varName = VarNameNDFA.checkToken(stream, "", index)

        cond do
          varName["finished"] ->
            checkToken(stream, xml_carry <> "\n" <> varName["xml"], varName["index"], 2)
          true ->
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      2 ->
        cond do
          tokenType == :symbol and token == "[" -> checkToken(stream, xml_carry <> "\n<symbol> [ </symbol>", nextIndex, 3)
          true -> checkToken(stream, xml_carry, index, 10)
        end

      3 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)

        cond do
          expression["finished"] -> checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 4)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      4 ->
        cond do
          tokenType == :symbol and token == "]" -> checkToken(stream, xml_carry <> "\n<symbol> ] </symbol>", nextIndex, 10)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      10 ->
        cond do
          tokenType == :symbol and token == "=" -> checkToken(stream, xml_carry <> "\n<symbol> = </symbol>", nextIndex, 11)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      11 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)

        cond do
          expression["finished"] -> checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 12)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      12 ->
        cond do
          tokenType == :symbol and token == ";" -> checkToken(stream, xml_carry <> "\n<symbol> ; </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting LetStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      100 ->
        IO.puts(">> Exiting LetStatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<letStatement>\n" <> xml_carry <> "\n</letStatement>"}
    end
  end
end
