defmodule SyntaxerDFA do
  def peek(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    IO.inspect("Peeking token " <> "--------------------> " <> tokenObj["token"])

    case tokenState do
      0 ->
        checkedToken = ClassNameNDFA.checkToken(stream, index)

        case checkedToken["finished"] do
          false -> SyntaxError.message("Wrong usage of " <> "(" <> checkedToken["token"] <> ")")
          true -> %{"finished" => true, "index" => tokenObj["index"], "token" => token}
        end
    end
  end

  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking ClassDef" <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "class" -> checkToken(stream, nextIndex, 1)
          true -> checkToken(stream, index, nil)
        end

      1 ->
        className = ClassNameNDFA.checkToken(stream, index)

        case className["finished"] do
          # * If error reading ClassName then return unexpected token
          false ->
            Syntax.unexpectedToken(token)

          true ->
            checkToken(stream, className["index"], 2)
        end

      2 ->
        case token do
          "{" ->
            checkToken(stream, nextIndex, 3)

          _ ->
            Syntax.unexpectedToken(token)
        end

      3 ->
        classVarDec = ClassVarDecNDFA.checkToken(stream, index)

        cond do
          classVarDec["finished"] == false ->
            subroutineDec = SubroutineDecNDFA.checkToken(stream, classVarDec["index"])

            cond do
              subroutineDec["finished"] == true ->
                checkToken(stream, subroutineDec["index"], 4)

              true ->
                Syntax.unexpectedToken(token)
            end

          classVarDec["finished"] == true ->
            checkToken(stream, classVarDec["index"], 4)

          true ->
            Syntax.unexpectedToken(token)

        end

      4 ->
        parameterList = ParameterListNDFA.checkToken(stream, index)

        case parameterList["finished"] do
          false -> Syntax.unexpectedToken(token)
          true -> checkToken(stream, parameterList["index"], 5)
        end

      5 ->
        subroutineBody = SubroutineBodyNDFA.checkToken(stream, index)

        case subroutineBody["finished"] do
          false -> Syntax.unexpectedToken(token)
          true -> checkToken(stream, subroutineBody["index"], 6)
        end

      6 ->
        statements = StatementsNDFA.checkToken(stream, index)

        case statements["finished"] do
          false -> IO.puts("oi")
          true -> checkToken(stream, statements["index"], 7)
        end

      7 ->
        IO.puts("END")

      nil ->
        IO.puts("Class read successifully")

        # 4 ->
        #   case token do
        #     "class" -> {}
        #   end

        # 5 ->
        #   case token do
        #     "class" -> {}
        #   end
    end
  end
end
