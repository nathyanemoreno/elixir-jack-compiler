defmodule VarNameNDFA do
  def checkToken(stream, index, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    #

    case tokenState do
      0 ->

        cond do
          # * If identifier get next
          tokenType == :identifier -> checkToken(stream, nextIndex, 100)

          true ->

            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->

        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
