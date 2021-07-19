defmodule UnaryOperatorNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token UnaryOperator " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case tokenState do
      0 ->
        cond do
          # * Go to state 100
          tokenType == :keyword ->
            case token do
              "-" ->
                checkToken(stream, nextIndex, 100)

              "~" ->
                checkToken(stream, nextIndex, 100)

              _ ->
                checkToken(stream, index, nil)
            end

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
