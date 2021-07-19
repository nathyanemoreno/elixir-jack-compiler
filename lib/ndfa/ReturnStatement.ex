defmodule ReturnStatementNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token ReturnStatement " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 1
          tokenType == :keyword and token == "return" -> checkToken(stream, nextIndex, 1)
          true -> checkToken(stream, nextIndex, 2)
        end

      1 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" -> checkToken(stream, nextIndex, 2)
          true -> checkToken(stream, nextIndex, 2)
        end

      2 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
