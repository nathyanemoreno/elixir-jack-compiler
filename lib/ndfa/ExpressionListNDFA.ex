defmodule ExpressionListNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token ExpressionListNDFA")
        expression = ExpressionNDFA.checkToken(stream, "", index)
        cond do
          expression["finished"] -> checkToken(stream, "\n" <> expression["xml"], expression["index"], 1)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      1 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, xml_carry <> "\n<symbol> , </symbol>", nextIndex, 2)
          true -> checkToken(stream, xml_carry, index, 100)
        end
      2 ->
        expression = ExpressionNDFA.checkToken(stream, "", index)
        cond do
          expression["finished"] -> checkToken(stream, xml_carry <> "\n" <> expression["xml"], expression["index"], 1)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<expressionList>" <> xml_carry <> "\n</expressionList>"}
    end
  end
end