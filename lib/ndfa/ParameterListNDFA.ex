defmodule ParameterListNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case state do
      0 ->
        IO.inspect("Checking token in ParameterList ")
        type = TypeNDFA.checkToken(stream, "", index)
        cond do
          type["finished"] -> checkToken(stream, "\n" , type["index"], 1)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      1 ->
        varName = VarNameNDFA.checkToken(stream, "", index)
        cond do
          varName["finished"] -> checkToken(stream, xml_carry , varName["index"], 2)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      2 ->
        cond do
          tokenType == :symbol and token == "," ->
            checkToken(stream, xml_carry <> "\n<symbol> , </symbol>", nextIndex, 3)
          true -> checkToken(stream, xml_carry, index, 100)
        end
      3 ->
        type = TypeNDFA.checkToken(stream, "", index)
        cond do
          type["finished"] -> checkToken(stream, xml_carry , type["index"], 4)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      4 ->
        varName = VarNameNDFA.checkToken(stream, "", index)
        cond do
          varName["finished"] -> checkToken(stream, xml_carry , varName["index"], 2)
          true ->
            checkToken(stream, xml_carry, index, 100)
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<parameterList>" <> xml_carry <> "\n</parameterList>"}
    end
  end
end
