defmodule ClassVarDecNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)
    IO.inspect(
      "Checking token in ClassVarDec " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case state do
      # * Read: keyword
      0 ->
        cond do
          # * If token is "field" or "static" got to state 1
          tokenType == :keyword and (token == "field" or token == "static") ->
            checkToken(stream, nextIndex, 1)

          # * Go to nil to go to subroutine
          true ->
            checkToken(stream, index, nil)
        end

      # * Read: type
      1 ->
        type = TypeNDFA.checkToken(stream, index)

        case type["finished"] do
          false ->
            Syntax.unexpectedToken(token)

          true ->
            checkToken(stream, type["index"], 2)
        end

      # * Read: varName
      2 ->
        varName = VarNameNDFA.checkToken(stream, index)

        case varName["finished"] do
          false ->
            Syntax.unexpectedToken(token)

          true ->
            checkToken(stream, varName["index"], 0)
        end

      nil ->
        # * Go to subroutine
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
