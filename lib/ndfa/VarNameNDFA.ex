defmodule VarNameNDFA do
  def checkToken(stream, xml_carry, index, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case tokenState do
      0 ->
        IO.puts("Checking token in VarName")
        cond do
          # * If identifier get next
          tokenType == :identifier -> checkToken(stream, "<identifier> " <> token <> " </identifier>", nextIndex, 100)

          true ->
            IO.puts(">> Exiting VarNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        IO.puts(">> Exiting VarNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
