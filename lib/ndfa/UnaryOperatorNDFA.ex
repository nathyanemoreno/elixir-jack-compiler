defmodule UnaryOperatorNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
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
                checkToken(stream, "<symbol> - </symbol>", nextIndex, 100)

              "~" ->
                checkToken(stream, "<symbol> ~ </symbol>", nextIndex, 100)

              _ ->
                IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
            end

          true ->
            IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "xml" => ""}
        end

      100 ->
        IO.puts(">> Exiting UnaryOperatorNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => xml_carry}
    end
  end
end
