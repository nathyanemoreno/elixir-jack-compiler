defmodule OperatorNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    
    case tokenState do
      0 ->
        IO.inspect(
          "Checking token Operator " <>
            "--------------------> " <>
            tokenObj["token"]
        )
        cond do
          # * Go to state 100
          tokenType == :symbol ->
            case token do
              "+" ->
                checkToken(stream, nextIndex, 100)

              "-" ->
                checkToken(stream, nextIndex, 100)

              "*" ->
                checkToken(stream, nextIndex, 100)

              "/" ->
                checkToken(stream, nextIndex, 100)

              "|" ->
                checkToken(stream, nextIndex, 100)

              "&amp;" ->
                checkToken(stream, nextIndex, 100)

              "&gt;" ->
                checkToken(stream, nextIndex, 100)

              "&lt;" ->
                checkToken(stream, nextIndex, 100)

              "=" ->
                checkToken(stream, nextIndex, 100)

              _ -> %{"finished" => false, "index" => index, "token" => token}
            end

          true -> %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
