defmodule ParameterListNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    IO.inspect(
      "Checking token in ParameterList " <>
        "--------------------> " <> tokenObj["token"]
    )

    case state do
      0 ->
        cond do
          # * Case is ( read again
          tokenType == :symbol and token == "(" ->
            checkToken(stream, nextIndex, 1)

          true ->
            checkToken(stream, nextIndex, nil)
        end

      1 ->
        cond do
          # * Case is ) end
          tokenType == :symbol and token == ")" ->
            checkToken(stream, nextIndex, 2)

          # * Case is , read again
          tokenType == :symbol and token == "," ->
            checkToken(stream, nextIndex, 1)

          # * Case is , read again
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, 2)

          # * Case is identifier
          true ->
            # * Get type
            type = TypeNDFA.checkToken(stream, index)

            cond do
              type["finished"] == true ->
                checkToken(stream, type["index"], 1)

              true ->
                # * Get varName
                varName = VarNameNDFA.checkToken(stream, index)

                cond do
                  varName["finished"] == true ->
                    checkToken(stream, varName["index"], 0)
                end
            end
        end

      2 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
