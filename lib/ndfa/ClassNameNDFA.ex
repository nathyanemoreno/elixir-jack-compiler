defmodule ClassNameNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    IO.inspect("Checking token in ClassName " <> "--------------------> " <> tokenObj["token"])

    case state do
      0 ->
        case tokenType do
          :identifier -> checkToken(stream, nextIndex, 1)
          _ -> checkToken(stream, nextIndex, nil)
        end

      1 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        # Syntax.unexpectedToken(token)
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
