defmodule UnaryOperatorNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]


    case tokenState do
      0 ->
        IO.inspect(
          "Checking token UnaryOperator")
        cond do
          # * Go to state 100
          tokenType == :symbol ->
            case token do
              "-" ->
                checkToken(stream, nextIndex, 100)

              "~" ->
                checkToken(stream, nextIndex, 100)

              _ ->
                IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token}
            end

          true ->
            IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end

      100 ->
        IO.puts(">> Exiting UnaryOperatorNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
