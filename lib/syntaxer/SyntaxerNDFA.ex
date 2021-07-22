defmodule SyntaxerNDFA do
  def peek(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    IO.puts(xml_carry)
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    IO.inspect("Peeking token " <> "--------------------> " <> tokenObj["token"])

    case tokenState do
      0 ->
        checkedToken = ClassNameNDFA.checkToken(stream, xml_carry, index)

        case checkedToken["finished"] do
          false -> SyntaxError.message("Wrong usage of " <> "(" <> checkedToken["token"] <> ")")
          true -> %{"finished" => true, "index" => tokenObj["index"], "token" => token}
        end
    end
  end

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
          tokenType == :keyword and token == "class" -> checkToken(stream, "<keyword> class </keyword>", nextIndex, 1)
          true ->
            Syntax.unexpectedToken(token)
            IO.puts(xml_carry)
        end

      1 ->
        className = ClassNameNDFA.checkToken(stream, xml_carry, index)

        case className["finished"] do
          # * If error reading ClassName then return unexpected token
          false ->
            Syntax.unexpectedToken(token)
            IO.puts(xml_carry)

          true ->
            checkToken(stream, xml_carry <> "\n" <> className["xml"], className["index"], 2)
        end

      2 ->
        case token do
          "{" ->
            checkToken(stream, xml_carry <> "\n<symbol> { </symbol>", nextIndex, 3)

          _ ->
            IO.puts(xml_carry)
            Syntax.unexpectedToken(token)
        end

      3 ->

        classVarDec = ClassVarDecNDFA.checkToken(stream, "", index)

        case classVarDec["finished"] do
          true -> checkToken(stream, xml_carry <> "\n" <> classVarDec["xml"], classVarDec["index"], 3)
          false -> checkToken(stream, xml_carry, classVarDec["index"], 4)
        end

      4 ->
        cond do
          tokenType == :symbol and token == "}" -> checkToken(stream, "<class>\n" <> xml_carry <> "\n<symbol> } </symbol>\n</class>", nextIndex, 100)
          true ->
            subroutineDec = SubroutineDecNDFA.checkToken(stream, xml_carry, index)
            
            case subroutineDec["finished"] do
              true -> checkToken(stream, xml_carry <> "\n" <> subroutineDec["xml"], subroutineDec["index"], 4)
              false ->
                IO.puts(xml_carry)
                Syntax.unexpectedToken(token)
            end
        end
      100 ->
        IO.puts("SUCCESS!")
        xml_carry
    end
  end
end
