defmodule VMIfStatementNDFA do
  def checkToken(stream, index, mModel \\ 0, tokenState \\ 0) do
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
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, mModel, 2)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            checkToken(stream, mModel <> "\n" <> expression["object"], expression["index"], 3)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, nextIndex, mModel, 4)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      4 ->
        cond do
          tokenType == :symbol and token == "{" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, mModel, 5)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      5 ->
        statements = VMStatementsNDFA.checkToken(stream, index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}

          true ->
            checkToken(stream, mModel <> "\n" <> statements["object"], statements["index"], 6)
        end

      6 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, nextIndex, mModel, 7)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      7 ->
        cond do
          tokenType == :keyword and token == "else" ->
            checkToken(stream, mModel <> "\n<keyword> else </keyword>", nextIndex, 8)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      8 ->
        cond do
          tokenType == :symbol and token == "{" ->
            checkToken(stream, nextIndex, mModel, 9)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      9 ->
        statements = VMStatementsNDFA.checkToken(stream, index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}

          true ->
            checkToken(stream, mModel <> "\n" <> statements["object"], statements["index"], 10)
        end

      10 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting IfStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting IfStatementNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => "<ifStatement>\n" <> mModel <> "\n</ifStatement>"
        }
    end
  end
end
