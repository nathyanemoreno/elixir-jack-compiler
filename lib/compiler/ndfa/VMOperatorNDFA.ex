defmodule VMOperatorNDFA do
  def checkToken(stream, index, mModel \\ %{"operator" => nil}, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token Operator")

        cond do
          # * Go to state 100
          tokenType == :symbol ->
            case token do
              "+" ->
                checkToken(stream, nextIndex, %{"operator" => "+"}, 100)

              "-" ->
                checkToken(stream, nextIndex, %{"operator" => "-"}, 100)

              "*" ->
                checkToken(stream, nextIndex, %{"operator" => "*"}, 100)

              "/" ->
                checkToken(stream, nextIndex, %{"operator" => "/"}, 100)

              "|" ->
                checkToken(stream, nextIndex, %{"operator" => "|"}, 100)

              "&amp;" ->
                checkToken(stream, nextIndex, %{"operator" => "&"}, 100)

              "&gt;" ->
                checkToken(stream, nextIndex, %{"operator" => ">"}, 100)

              "&lt;" ->
                checkToken(stream, nextIndex, %{"operator" => "<"}, 100)

              "=" ->
                checkToken(stream, nextIndex, %{"operator" => "="}, 100)

              _ ->
                IO.puts(">> Exiting OperatorNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token, "object" => ""}
            end

          true ->
            IO.puts(">> Exiting OperatorNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting OperatorNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
