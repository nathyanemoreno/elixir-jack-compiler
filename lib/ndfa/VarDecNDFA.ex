defmodule VarDecNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    IO.inspect(
      "Checking token in VarDec " <>
        "--------------------> " <> tokenObj["token"]
    )

    case state do
      0 ->
        cond do
          # * If keyword var get next
          tokenType == :keyword and token == "var" ->
            checkToken(stream, nextIndex, 1)

          true ->
            checkToken(stream, index, nil)
        end

      1 ->
        type = TypeNDFA.checkToken(stream, index)

        case type["finished"] do
          false -> Syntax.unexpectedToken(token)
          true -> checkToken(stream, type["index"], 2)
        end

      2 ->
        varName = VarNameNDFA.checkToken(stream, index)

        cond do
          # * Read again
          varName["finished"] == true ->
            checkToken(stream, varName["index"], 2)

          # * Case is , read again
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 1)

          # # * Case is ; read again
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, 3)

          true ->
            checkToken(stream, nextIndex, 2)
        end

      3 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
