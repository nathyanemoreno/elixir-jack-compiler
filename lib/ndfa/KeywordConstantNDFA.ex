defmodule KeywordConstantNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token KeywordConstant " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          tokenType == :keyword and token == "true" -> checkToken(stream, nextIndex, 100)
          tokenType == :keyword and token == "false" -> checkToken(stream, nextIndex, 100)
          tokenType == :keyword and token == "null" -> checkToken(stream, nextIndex, 100)
          tokenType == :keyword and token == "this" -> checkToken(stream, nextIndex, 100)
          true -> checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
