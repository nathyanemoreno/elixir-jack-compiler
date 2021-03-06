defmodule TermNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token TermNDFA")
        cond do
          # * Go to state 1
          tokenType == :integerConstant -> checkToken(stream, "<integerConstant> " <> token <> " </integerConstant>", nextIndex, 100)
          tokenType == :stringConstant -> checkToken(stream, "<stringConstant> " <> token <> " </stringConstant>", nextIndex, 100)
          tokenType == :symbol and token == "(" -> checkToken(stream, "<symbol> ( </symbol>", nextIndex, 1)
          true ->
            # * Verify if is KeywordConstant
            keywordConstant = KeywordConstantNDFA.checkToken(stream, "", index)

            cond do
              keywordConstant["finished"]-> checkToken(stream, keywordConstant["xml"], keywordConstant["index"], 100)
              true ->
                subroutineCall = SubroutineCallNDFA.checkToken(stream, "", index)

                cond do
                  subroutineCall["finished"] -> checkToken(stream, subroutineCall["xml"], subroutineCall["index"], 100)
                  true ->
                    # * Verify if is VarName
                    varName = VarNameNDFA.checkToken(stream, "", index)

                    cond do
                      varName["finished"] -> checkToken(stream, varName["xml"], varName["index"], 10)
                      true ->
                        unaryOperator = UnaryOperatorNDFA.checkToken(stream, "", index)

                        cond do
                          unaryOperator["finished"] -> checkToken(stream, unaryOperator["xml"], unaryOperator["index"], 20)
                          true ->
                            IO.puts(">> Exiting TermNDFA (FAILED)")
                            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
                        end
                      end
                    end
                  end
                end
      1 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)

        cond do
          expression["finished"] -> checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 2)
          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      2 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, xml_carry <> "<symbol> ) </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      10 ->
        cond do
          tokenType == :symbol and token == "[" -> checkToken(stream, xml_carry <> "<symbol> [ </symbol>", nextIndex, 11)
          true -> checkToken(stream, xml_carry, index, 100)
        end
      11 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)

        cond do
          expression["finished"] -> checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 12)
          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      12 ->
        cond do
          tokenType == :symbol and token == "]" -> checkToken(stream, xml_carry <> "<symbol> ] </symbol>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      20 ->
        term = TermNDFA.checkToken(stream, "", index)

        cond do
          term["finished"] -> checkToken(stream, xml_carry <> "\n" <> term["xml"], term["index"], 100)
          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end
      100 ->
        IO.puts(">> Exiting TermNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<term>\n" <> xml_carry <> "\n</term>"}
    end
  end
end
