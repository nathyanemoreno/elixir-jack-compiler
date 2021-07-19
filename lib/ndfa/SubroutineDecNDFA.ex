defmodule SubroutineDecNDFA do
  def checkToken(stream, index, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]

    IO.inspect(
      "Checking token in SubroutineDec " <>
        "--------------------> " <>
        tokenObj["token"]
    )

    case state do
      # Read: keyword
      0 ->
        cond do
          tokenType == :keyword and
              (token == "constructor" or token == "function" or token == "method") ->
            checkToken(stream, nextIndex, 1)

          true ->
            checkToken(stream, index, nil)
        end

      1 ->
        type = TypeNDFA.checkToken(stream, index)

        cond do
          (tokenType == :keyword and token == "void") or type["finished"] == true ->
            subroutine = SubroutineNameNDFA.checkToken(stream, index)

            case subroutine["finished"] do
              false ->
                Syntax.unexpectedToken(token)

              true ->
                checkToken(stream, subroutine["index"], 2)
            end

          true ->
            IO.puts("Syntax error")
        end

      # Read: type
      2 ->
        type = TypeNDFA.checkToken(stream, index)

        case type["finished"] do
          false ->
            Syntax.unexpectedToken(token)

          true ->
            checkToken(stream, type["index"], 3)
        end

      # Read: varName
      3 ->
        %{"finished" => true, "index" => index, "token" => token}

      nil ->
        %{"finished" => false, "index" => index, "token" => token}
    end
  end
end
