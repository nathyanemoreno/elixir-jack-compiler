defmodule TypeNDFA do
  def checkToken(stream, xml_carry, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    
    case state do
      # Read: keyword
      0 ->
        IO.inspect("Checking token in Type")
        
        cond do
          tokenType == :keyword and token == "int" ->
            checkToken(stream, "<keyword> int </keyword>", nextIndex, 100)
            
          tokenType == :keyword and token == "char" ->
            checkToken(stream, "<keyword> char </keyword>", nextIndex, 100)
            
          tokenType == :keyword and token == "boolean" ->
            checkToken(stream, "<keyword> boolean </keyword>", nextIndex, 100)
            
          true ->
            className = ClassNameNDFA.checkToken(stream, "", index)
            
            cond do
              className["finished"] ->
                checkToken(stream, xml_carry <> className["xml"], className["index"], 100)
              true ->
                IO.puts(">> Exiting TypeNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
            end
        end

      100 ->
        IO.puts(">> Exiting TypeNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}
    end
  end
end
