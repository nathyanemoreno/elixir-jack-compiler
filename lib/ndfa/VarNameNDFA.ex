defmodule VarNameNDFA do
  def checkToken(stream, index, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token in VarName " <>
            "--------------------> " <> tokenObj["token"]
        )
        cond do
          # * If identifier get next
          tokenType == :identifier ->
            checkToken(stream, nextIndex, 100)

          true ->
            checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
