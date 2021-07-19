defmodule SubroutineCallNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token SubroutineCall " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 100
          # tokenType == :keyword and token == "let" -> checkToken(stream, nextIndex, 1)
          true -> checkToken(stream, index, nil)
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
