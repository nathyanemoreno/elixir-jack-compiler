defmodule VMTermNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "kind" => nil,
          "term" => nil
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.puts("Checking token TermNDFA")

        cond do
          # * Go to state 1
          tokenType == :integerConstant ->
            mModel =
              Map.replace(
                Map.replace(
                  mModel,
                  "kind",
                  :integerConstant
                ),
                "term",
                token
              )

            checkToken(stream, nextIndex, mModel, 100)

          tokenType == :stringConstant ->
            mModel =
              Map.replace(
                Map.replace(
                  mModel,
                  "kind",
                  :stringConstant
                ),
                "term",
                token
              )

            checkToken(stream, nextIndex, mModel, 100)

          tokenType == :symbol and token == "(" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            # * Verify if is KeywordConstant
            keywordConstant = VMKeywordConstantNDFA.checkToken(stream, index)

            cond do
              keywordConstant["finished"] ->
                mModel =
                  Map.replace(
                    Map.replace(
                      mModel,
                      "kind",
                      :keywordConstant
                    ),
                    "term",
                    keywordConstant["object"]["name"]
                  )

                checkToken(stream, keywordConstant["index"], mModel, 100)

              true ->
                subroutineCall = VMSubroutineCallNDFA.checkToken(stream, index)
                IO.inspect(subroutineCall)

                cond do
                  subroutineCall["finished"] ->
                    mModel =
                      Map.replace(
                        Map.replace(
                          mModel,
                          "kind",
                          :subroutineCall
                        ),
                        "term",
                        subroutineCall["object"]
                      )

                    checkToken(stream, subroutineCall["index"], mModel, 100)

                  true ->
                    # * Verify if is VarName
                    varName = VMVarNameNDFA.checkToken(stream, index)

                    cond do
                      varName["finished"] ->
                        mModel =
                          Map.replace(
                            Map.replace(
                              mModel,
                              "kind",
                              :variable
                            ),
                            "term",
                            token
                          )

                        checkToken(stream, varName["index"], mModel, 10)

                      true ->
                        unaryOperator = VMUnaryOperatorNDFA.checkToken(stream, index)

                        cond do
                          unaryOperator["finished"] ->
                            mModel = Map.replace(mModel, "kind", :unaryTerm)
                            mModel = Map.replace(mModel, "term", [unaryOperator["object"]])

                            checkToken(
                              stream,
                              unaryOperator["index"],
                              mModel,
                              20
                            )

                          true ->
                            IO.puts(">> Exiting TermNDFA (FAILED)")

                            %{
                              "finished" => false,
                              "index" => index,
                              "token" => token,
                              "object" => ""
                            }
                        end
                    end
                end
            end
        end

      1 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            mModel =
              Map.replace(
                Map.replace(
                  mModel,
                  "kind",
                  :expression
                ),
                "term",
                expression["object"]["expression"]
              )

            checkToken(stream, expression["index"], mModel, 2)

          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      10 ->
        cond do
          tokenType == :symbol and token == "[" ->
            checkToken(stream, nextIndex, mModel, 11)

          true ->
            checkToken(stream, index, mModel, 100)
        end

      11 ->
        expression = VMExpressionNDFA.checkToken(stream, index)

        cond do
          expression["finished"] ->
            checkToken(stream, expression["index"], mModel, 12)

          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      12 ->
        cond do
          tokenType == :symbol and token == "]" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      20 ->
        term = VMTermNDFA.checkToken(stream, index)

        cond do
          term["finished"] ->
            mModel = Map.replace(mModel, "term", mModel["term"] ++ [term["object"]])
            checkToken(stream, term["index"], mModel, 100)

          true ->
            IO.puts(">> Exiting TermNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting TermNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
