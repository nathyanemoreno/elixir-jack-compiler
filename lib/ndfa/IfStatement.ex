defmodule IfStatementNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token IfStatement")

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "if" ->
            checkToken(stream, "<keyword> if </keyword>", nextIndex, 1)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            # * If find ( look for expression
            checkToken(stream, xml_carry <> "\n<symbol> ( </symbol>", nextIndex, 2)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      2 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)

        cond do
          expression["finished"] ->
            checkToken(stream, xml_carry , expression["index"], 3)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, xml_carry <> "\n<symbol> ) </symbol>", nextIndex, 4)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      4 ->
        cond do
          tokenType == :symbol and token == "{" ->
            # * If find ( look for expression
            checkToken(stream, xml_carry <> "\n<symbol> { </symbol>", nextIndex, 5)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      5 ->
        statements = StatementsNDFA.checkToken(stream, "", index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}

          true ->
            checkToken(stream, xml_carry , statements["index"], 6)
        end

      6 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, xml_carry <> "\n<symbol> } </symbol>", nextIndex, 7)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      7 ->
        cond do
          tokenType == :keyword and token == "else" ->
            checkToken(stream, xml_carry <> "\n<keyword> else </keyword>", nextIndex, 8)

          true ->
            checkToken(stream, xml_carry, index, 100)
        end

      8 ->
        cond do
          tokenType == :symbol and token == "{" ->
            checkToken(stream, xml_carry <> "\n<symbol> { </symbol>", nextIndex, 9)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      9 ->
        statements = StatementsNDFA.checkToken(stream, "", index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}

          true ->
            checkToken(stream, xml_carry , statements["index"], 10)
        end

      10 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, xml_carry <> "\n<symbol> } </symbol>", nextIndex, 100)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        IO.puts(">> Exiting IfStatementNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "xml" => "<ifStatement>\n" <> xml_carry <> "\n</ifStatement>"
        }
    end
  end
end
