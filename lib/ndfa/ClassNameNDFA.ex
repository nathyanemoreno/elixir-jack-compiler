defmodule ClassNameNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]

    case state do
      0 ->

        case tokenType do
          :identifier -> checkToken(stream, nextIndex, 100)
          _ ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
