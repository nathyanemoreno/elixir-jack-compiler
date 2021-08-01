defmodule SyntaxerNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
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
          tokenType == :keyword and token == "class" ->
            checkToken(stream, "<keyword> class </keyword>", nextIndex, 1)

          true ->
            IO.puts(xml_carry)
            {:error, token}
        end

      1 ->
        className = ClassNameNDFA.checkToken(stream, xml_carry, index)

        case className["finished"] do
          true ->
            checkToken(stream, xml_carry <> "\n" <> className["xml"], className["index"], 2)

          # * If error reading ClassName then return unexpected token
          false ->
            IO.puts(xml_carry)
            {:error, token}
        end

      2 ->
        case token do
          "{" ->
            checkToken(stream, xml_carry <> "\n<symbol> { </symbol>", nextIndex, 3)

          _ ->
            IO.puts(xml_carry)
            {:error, token}
        end

      3 ->
        classVarDec = ClassVarDecNDFA.checkToken(stream, "", index)

        case classVarDec["finished"] do
          true ->
            checkToken(stream, xml_carry <> "\n" <> classVarDec["xml"], classVarDec["index"], 3)

          false ->
            checkToken(stream, xml_carry, classVarDec["index"], 4)
        end

      4 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(
              stream,
              "<class>\n" <> xml_carry <> "\n<symbol> } </symbol>\n</class>",
              nextIndex,
              100
            )

          true ->
            subroutineDec = SubroutineDecNDFA.checkToken(stream, xml_carry, index)

            case subroutineDec["finished"] do
              true ->
                checkToken(
                  stream,
                  xml_carry <> "\n" <> subroutineDec["xml"],
                  subroutineDec["index"],
                  4
                )

              false ->
                IO.puts(xml_carry)
                {:error, "Syntax error"}
            end
        end

      100 ->
        {:ok, xml_carry}
    end
  end
end
