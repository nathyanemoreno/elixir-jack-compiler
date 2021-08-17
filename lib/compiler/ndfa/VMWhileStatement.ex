defmodule VMWhileStatementNDFA do
  def checkToken(stream, index, mModel \\ 0, tokenState \\ 0) do
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
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, mModel, 2)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            checkToken(stream, mModel <> "\n" <> expression["object"], expression["index"], 3)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, nextIndex, mModel, 4)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end
      4 ->
        cond do
          tokenType == :symbol and token == "{" ->
            # * If find ( look for expression
            checkToken(stream, nextIndex, mModel, 5)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      5 ->
        statements = VMStatementsNDFA.checkToken(stream, index)

        case statements["finished"] do
          false ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
          true ->
            checkToken(stream, mModel <> "\n" <> statements["object"], statements["index"], 6)
        end

      6 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(stream, nextIndex, mModel, 100)
          true ->
            IO.puts(">> Exiting WhileStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting WhileStatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => "<whileStatement>\n" <> mModel <> "\n</whileStatement>"}
    end
  end
end
