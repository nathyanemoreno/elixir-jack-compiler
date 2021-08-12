defmodule SyntaxerNDFA do
  def checkToken(stream, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect(
          "Checking ClassDef" <>
            "--------------------> " <>
            tokenObj["token"]
        )

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "class" ->
            checkToken(stream, nextIndex, 1)

          true ->
            {:error, token}
        end

      1 ->
        className = ClassNameNDFA.checkToken(stream, "", index)

        case className["finished"] do
          true ->
            checkToken(stream, className["index"], 2)

          # * If error reading ClassName then return unexpected token
          false ->
            {:error, token}
        end

      2 ->
        case token do
          "{" ->
            checkToken(stream, nextIndex, 3)

          _ ->
            {:error, token}
        end

      3 ->
        classVarDec = ClassVarDecNDFA.checkToken(stream, "", index)

        case classVarDec["finished"] do
          true ->
            checkToken(stream, classVarDec["index"], 3)

          false ->
            checkToken(stream, classVarDec["index"], 4)
        end

      4 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(
              stream,
              nextIndex,
              100
            )

          true ->
            subroutineDec = SubroutineDecNDFA.checkToken(stream, "", index)

            case subroutineDec["finished"] do
              true ->
                checkToken(
                  stream,
                  subroutineDec["index"],
                  4
                )

              false ->
                {:error, "Syntax error"}
            end
        end

      100 ->
        {:ok, "Okay"}
    end
  end
end
