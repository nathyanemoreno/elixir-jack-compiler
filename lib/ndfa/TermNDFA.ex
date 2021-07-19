defmodule TermNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token TermNDFA " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 1
          tokenType == :integerConstant -> checkToken(stream, nextIndex, 100)
          tokenType == :stringConstant -> checkToken(stream, nextIndex, 100)
          tokenType == :symbol and token == "(" -> checkToken(stream, nextIndex, 1)
          true ->
            # * Verify if is KeywordConstant
            keywordConstant = KeywordConstantNDFA.checkToken(stream, index)

            cond do
              keywordConstant["finished"]-> checkToken(stream, keywordConstant["index"], 100)
              true ->
                # * Verify if is VarName
                varName = VarNameNDFA.checkToken(stream, index)

                cond do
                  varName["finished"] -> checkToken(stream, varName["index"], 10)
                  true ->
                    subroutineCall = SubroutineCallNDFA.checkToken(stream, index)

                    cond do
                      subroutineCall["finished"] -> checkToken(stream, subroutineCall["index"], 100)
                      true ->
                        unaryOperator = UnaryOperatorNDFA.checkToken(stream, index)

                        cond do
                          unaryOperator["finished"] -> checkToken(stream, unaryOperator["index"], 20)
                          true -> %{"finished" => false, "index" => index, "token" => token}
                        end
                      end
                    end
                  end
                end
      1 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] -> checkToken(stream, expression["index"], 2)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      2 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      10 ->
        cond do
          tokenType == :symbol and token == "[" -> checkToken(stream, nextIndex, 11)
          true -> checkToken(stream, index, 100)
        end
      11 ->
        expression = ExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] -> checkToken(stream, expression["index"], 12)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      12 ->
        cond do
          tokenType == :symbol and token == "]" -> checkToken(stream, nextIndex, 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      20 ->
        term = TermNDFA.checkToken(stream, index)

        cond do
          term["finished"] -> checkToken(stream, term["index"], 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
