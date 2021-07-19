defmodule Expression do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token Expression " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 1
          tokenType == :integerConstant ->
            checkToken(stream, nextIndex, 100)

          tokenType == :stringConstant ->
            checkToken(stream, nextIndex, 100)

          true ->
            # * Verify if is KeywordConstant
            keywordConstant = KeywordConstantNDFA.checkToken(stream, index)

            case keywordConstant["finished"] do
              false ->
                # * Verify if is VarName
                varName = VarNameNDFA.checkToken(stream, index)

                case varName["finished"] do
                  false ->
                    subroutineCall = SubroutineCallNDFA.checkToken(stream, index)

                    case subroutineCall["finished"] do
                      false ->
                        # IO.puts(subroutineCall["token"])

                        cond do
                          # * Verify Expression
                          subroutineCall["token"] == "(" ->
                            expression = Expression.checkToken(stream, nextIndex)

                            case expression["finished"] do
                              # * Verify UnaryOperator
                              false ->
                                IO.puts("oi")
                                # unaryOperator = UnaryOperatorNDFA.checkToken(stream, index)

                                # case unaryOperator["finished"] do
                                #   false ->
                                #     # TODO Read term
                                #     checkToken(stream, nextIndex, 100)

                                #   true ->
                                #     checkToken(stream, index, nil)
                                # end

                              true ->
                                cond do
                                  expression["token"] == ")" ->
                                    checkToken(stream, nextIndex, 100)

                                  true ->
                                    checkToken(stream, index, nil)
                                end
                            end
                        end

                      true ->
                        checkToken(stream, nextIndex, 100)
                    end

                  true ->
                    # TODO check [expression]
                    checkToken(stream, nextIndex, 100)
                end

              true ->
                checkToken(stream, nextIndex, 100)
            end

          true ->
            checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
