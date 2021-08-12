defmodule OperatorNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]


    case tokenState do
      0 ->
        IO.inspect(
          "Checking token Operator")
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

              _ ->
                IO.puts(">> Exiting OperatorNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token}
            end

          true ->
            IO.puts(">> Exiting OperatorNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        IO.puts(">> Exiting OperatorNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
