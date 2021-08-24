defmodule VMUnaryOperatorNDFA do
  def checkToken(stream, index, mModel \\ %{"operator" => nil}, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token UnaryOperator")

        cond do
          # * Go to state 100
          tokenType == :symbol ->
            case token do
              "-" ->
                mModel = Map.replace(mModel, "operator", "-")
                checkToken(stream, nextIndex, mModel, 100)

              "~" ->
                mModel = Map.replace(mModel, "operator", "~")
                checkToken(stream, nextIndex, mModel, 100)

              _ ->
                IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token, "object" => ""}
            end

          true ->
            IO.puts(">> Exiting UnaryOperatorNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting UnaryOperatorNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
