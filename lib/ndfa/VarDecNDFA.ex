defmodule VarDecNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    
    case state do
      0 ->
        IO.inspect(
          "Checking token in VarDec ")
        cond do
          # * If keyword var get next
          tokenType == :keyword and token == "var" ->
            checkToken(stream, xml_carry, nextIndex, 1)

          true ->
            checkToken(stream, xml_carry, index, nil)
        end

      1 ->
        type = TypeNDFA.checkToken(stream, "", index)

        case type["finished"] do
          false -> Syntax.unexpectedToken(token)
          true -> checkToken(stream, xml_carry, type["index"], 2)
        end

      2 ->
        varName = VarNameNDFA.checkToken(stream, "", index)

        cond do
          # * Read again
          varName["finished"] == true ->
            checkToken(stream, xml_carry, varName["index"], 2)

          # * Case is , read again
          tokenType == :symbol and token == "," ->
            checkToken(stream, xml_carry, nextIndex, 1)

          # # * Case is ; read again
          tokenType == :symbol and token == ";" ->
            checkToken(stream, xml_carry, nextIndex, 3)

          true ->
            checkToken(stream, xml_carry, nextIndex, 2)
        end

      3 ->
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}

      nil ->
        %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
    end
  end
end
