defmodule VMStatementNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "kind" => nil,
          "statment" => nil
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token Statement")
        letStatement = VMLetStatementNDFA.checkToken(stream, index)

        cond do
          letStatement["finished"] ->
            mModel =
              Map.replace(
                Map.replace(mModel, "kind", "let"),
                "statment",
                letStatement["object"]
              )

            checkToken(stream, letStatement["index"], mModel, 100)

          true ->
            ifStatement = VMIfStatementNDFA.checkToken(stream, index)

            cond do
              ifStatement["finished"] ->
                mModel =
                  Map.replace(
                    Map.replace(mModel, "kind", "if"),
                    "statment",
                    ifStatement["object"]
                  )

                checkToken(stream, ifStatement["index"], mModel, 100)

              true ->
                whileStatement = VMWhileStatementNDFA.checkToken(stream, index)

                cond do
                  whileStatement["finished"] ->
                    mModel =
                      Map.replace(
                        Map.replace(mModel, "kind", "while"),
                        "statment",
                        whileStatement["object"]
                      )

                    checkToken(stream, whileStatement["index"], mModel, 100)

                  true ->
                    doStatment = VMDoStatementNDFA.checkToken(stream, index)

                    cond do
                      doStatment["finished"] ->
                        mModel =
                          Map.replace(
                            Map.replace(mModel, "kind", "do"),
                            "statment",
                            doStatment["object"]
                          )

                        checkToken(stream, doStatment["index"], mModel, 100)

                      true ->
                        returnStatement = VMReturnStatementNDFA.checkToken(stream, index)

                        cond do
                          returnStatement["finished"] ->
                            mModel =
                              Map.replace(
                                Map.replace(mModel, "kind", "return"),
                                "statment",
                                returnStatement["object"]
                              )

                            checkToken(
                              stream,
                              returnStatement["index"],
                              mModel,
                              100
                            )

                          true ->
                            IO.puts(">> Exiting StatementNDFA (FAILED)")

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

      100 ->
        IO.puts(">> Exiting StatementNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
