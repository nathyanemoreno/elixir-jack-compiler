defmodule SubroutineBodyNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    IO.inspect(
      "Checking token in SubroutineBody " <>
        "--------------------> " <> tokenObj["token"]
    )

    case state do
      0 ->
        cond do
          # * Case is { read again
          tokenType == :symbol and token == "{" ->
            checkToken(stream, nextIndex, 1)

          # * Case is } end
          tokenType == :symbol and token == "}" ->
            checkToken(stream, nextIndex, 2)

          true ->
            checkToken(stream, nextIndex, nil)
        end

      1 ->
        varDec = VarDecNDFA.checkToken(stream, index)

        case varDec["finished"] do
          false ->
            letStatement = LetStatementNDFA.checkToken(stream, varDec["index"])

            case letStatement["finished"] do
              false ->
                ifStatement = IfStatementNDFA.checkToken(stream, letStatement["index"])

                case ifStatement["finished"] do
                  false ->
                    IO.puts(letStatement["token"])
                    # whileStatement = WhileStatementNDFA.checkToken(stream, index)

                  #         case whileStatement["finished"] do
                  #           false ->
                  #             doStatement = DoStatementNDFA.checkToken(stream, index)

                  #             case doStatement["finished"] do
                  #               false ->
                  #                 returnStatement = ReturnStatementNDFA.checkToken(stream, index)

                  #                 case returnStatement["finished"] do
                  #                   false ->
                  #                     checkToken(stream, returnStatement["index"], 2)

                  #                   true ->
                  #                     checkToken(stream, letStatement["index"], 2)
                  #                 end

                  #               true ->
                  #                 checkToken(stream, letStatement["index"], 2)
                  #             end

                  #           true ->
                  #             checkToken(stream, letStatement["index"], 2)
                  #         end

                  true ->
                    checkToken(stream, letStatement["index"], 2)
                end

              true ->
                checkToken(stream, letStatement["index"], nil)
            end

          true ->
            checkToken(stream, varDec["index"], 1)

          _ ->
            true
        end

      2 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
