defmodule SubroutineNameNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    
    case state do
      0 ->
        IO.puts("Checking token in SubroutineNameNDFA")
        cond do
          # * If identifier get next
          tokenType == :identifier -> checkToken(stream, "<identifier> " <> token <> " </identifier>", nextIndex, 100)
          true -> 
            IO.puts(">> Exiting SubroutineNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      100 ->
        IO.puts(">> Exiting SubroutineNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}
    end
  end
end
