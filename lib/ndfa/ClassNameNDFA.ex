defmodule ClassNameNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case state do
      0 ->
        IO.inspect("Checking token in ClassName " <> "--------------------> " <> tokenObj["token"])
        case tokenType do
          :identifier -> checkToken(stream, nextIndex, 100)
          _ ->
            IO.puts(">> Exiting ClassNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        IO.puts(">> Exiting ClassNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
