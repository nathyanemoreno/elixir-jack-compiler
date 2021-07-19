defmodule SubroutineNameNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token= tokenObj["token"]
    # IO.inspect(tokenType)
    
    case state do
      0 ->
        IO.inspect("Checking token SubroutineName " <> "--------------------> " <> tokenObj["token"])
        case tokenType do
          :identifier -> checkToken(stream, index, 1)
          _ -> IO.puts("Syntax error")
        end

      1 ->
        %{"finished" => true, "index" => tokenObj["index"], "token" => token}

      _ ->
        false
    end
  end
end
