defmodule KeywordConstantNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]
    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token KeywordConstant")
        cond do
          tokenType == :keyword and token == "true" -> checkToken(stream, "<keyword> true </keyword>", nextIndex, 100)
          tokenType == :keyword and token == "false" -> checkToken(stream, "<keyword> false </keyword>", nextIndex, 100)
          tokenType == :keyword and token == "null" -> checkToken(stream, "<keyword> null </keyword>", nextIndex, 100)
          tokenType == :keyword and token == "this" -> checkToken(stream, "<keyword> this </keyword>", nextIndex, 100)
          true ->
            IO.puts(">> Exiting KeywordConstantNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      100 ->
        IO.puts(">> Exiting KeywordConstantNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}
    end
  end
end
