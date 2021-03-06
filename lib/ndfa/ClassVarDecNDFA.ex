defmodule ClassVarDecNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case state do
      # * Read: keyword
      0 ->
        IO.inspect("Checking token in ClassVarDec")

        cond do
          # * If token is "field" or "static" got to state 1
          tokenType == :keyword and (token == "field" or token == "static") ->
            checkToken(stream, "<keyword> " <> token <> " </keyword>", nextIndex, 1)

          # * Go to nil to go to subroutine
          true ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      # * Read: type
      1 ->
        type = TypeNDFA.checkToken(stream, "", index)

        case type["finished"] do
          false ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}

          true ->
            checkToken(stream, xml_carry <> "\n" <> type["xml"], type["index"], 2)
        end

      # * Read: varName
      2 ->
        varName = VarNameNDFA.checkToken(stream, "", index)

        case varName["finished"] do
          false ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}

          true ->
            checkToken(stream, xml_carry <> "\n" <> varName["xml"], varName["index"], 3)
        end

      3 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, xml_carry <> "\n<symbol> , </symbol>", nextIndex, 4)

          tokenType == :symbol and token == ";" ->
            checkToken(stream, xml_carry <> "\n<symbol> ; </symbol>", nextIndex, 100)

          true ->
            IO.puts(">> Exiting ClassVarDecNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      4 ->
        varName = VarNameNDFA.checkToken(stream, "", index)
        checkToken(stream, xml_carry <> "\n" <> varName["xml"], varName["index"], 3)

      100 ->
        IO.puts(">> Exiting ClassVarDecNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "xml" => "<classVarDec>\n" <> xml_carry <> "\n</classVarDec>"
        }
    end
  end
end
