defmodule OperatorNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
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
                checkToken(stream,  "<symbol> + </symbol>", nextIndex, 100)

              "-" ->
                checkToken(stream,  "<symbol> - </symbol>", nextIndex, 100)

              "*" ->
                checkToken(stream,  "<symbol> * </symbol>", nextIndex, 100)

              "/" ->
                checkToken(stream,  "<symbol> / </symbol>", nextIndex, 100)

              "|" ->
                checkToken(stream,  "<symbol> | </symbol>", nextIndex, 100)

              "&amp;" ->
                checkToken(stream,  "<symbol> &amp; </symbol>", nextIndex, 100)

              "&gt;" ->
                checkToken(stream,  "<symbol> &gt; </symbol>", nextIndex, 100)

              "&lt;" ->
                checkToken(stream,  "<symbol> &lt; </symbol>", nextIndex, 100)

              "=" ->
                checkToken(stream,  "<symbol> = </symbol>", nextIndex, 100)

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
