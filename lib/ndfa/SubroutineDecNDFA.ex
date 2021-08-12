defmodule SubroutineDecNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]


    case state do
      # Read: keyword
      0 ->
        IO.puts("Checking token in SubroutineDec")
        cond do
          tokenType == :keyword and
              (token == "constructor" or token == "function" or token == "method") ->
            checkToken(stream, "<keyword> " <> token <> " </keyword>", nextIndex, 1)

          true ->
            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        cond do
          tokenType == :keyword and token == "void" -> checkToken(stream, xml_carry <> "\n<keyword> void </keyword>", nextIndex, 2)
          true ->
            type = TypeNDFA.checkToken(stream, "", index)

            cond do
              type["finished"] -> checkToken(stream, xml_carry , type["index"], 2)
              true -> %{"finished" => false, "index" => index, "token" => token}
            end
        end
      2 ->
        subroutineName = SubroutineNameNDFA.checkToken(stream, "", index)
        cond do
          subroutineName["finished"] -> checkToken(stream, xml_carry , subroutineName["index"], 3)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          tokenType == :symbol and token == "(" -> checkToken(stream, xml_carry <> "\n<symbol> ( </symbol>", nextIndex, 4)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      4 ->
        parameterList = ParameterListNDFA.checkToken(stream, "", index)
        cond do
          parameterList["finished"] -> checkToken(stream, xml_carry , parameterList["index"], 5)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
        5 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, xml_carry <> "\n<symbol> ) </symbol>", nextIndex, 6)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      6 ->
        subroutineBody = SubroutineBodyNDFA.checkToken(stream, "", index)
        cond do
          subroutineBody["finished"] -> checkToken(stream, xml_carry , subroutineBody["index"], 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<subroutineDec>\n" <> xml_carry <> "\n</subroutineDec>"}
    end
  end
end
