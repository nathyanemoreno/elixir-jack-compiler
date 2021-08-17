defmodule VMClassDefNDFA do
  def checkToken(
        stream,
        index \\ 0,
        mModel \\ %{
          "className" => nil,
          "fields" => [],
          "statics" => [],
          "constructors" => [],
          "methods" => [],
          "functions" => []
        },
        tokenState \\ 0
      ) do
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
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            {:error, token}
        end

      1 ->
        className = VMClassNameNDFA.checkToken(stream, index)

        case className["finished"] do
          true ->
            mModel = Map.replace(mModel, "className", className["object"]["name"])
            checkToken(stream, className["index"], mModel, 2)

          # * If error reading ClassName then return unexpected token
          false ->
            IO.puts(mModel)
            {:error, token}
        end

      2 ->
        case token do
          "{" ->
            checkToken(stream, nextIndex, mModel, 3)

          _ ->
            IO.puts(mModel)
            {:error, token}
        end

      3 ->
        classVarDec = VMClassVarDecNDFA.checkToken(stream, index)

        case classVarDec["finished"] do
          true ->
            case classVarDec["object"]["kind"] do
              "field" ->
                mModel =
                  Map.replace(
                    mModel,
                    "fields",
                    mModel["fields"] ++ [classVarDec["object"]]
                  )

                checkToken(
                  stream,
                  classVarDec["index"],
                  mModel,
                  3
                )

              "static" ->
                mModel =
                  Map.replace(
                    mModel,
                    "statics",
                    mModel["statics"] ++ [classVarDec["object"]]
                  )

                checkToken(
                  stream,
                  classVarDec["index"],
                  mModel,
                  3
                )
            end

          false ->
            checkToken(stream, classVarDec["index"], mModel, 4)
        end

      4 ->
        cond do
          tokenType == :symbol and token == "}" ->
            checkToken(
              stream,
              nextIndex,
              mModel,
              100
            )

          true ->
            subroutineDec = VMSubroutineDecNDFA.checkToken(stream, index)

            case subroutineDec["finished"] do
              true ->
                case subroutineDec["object"]["kind"] do
                  "constructor" ->
                    mModel =
                      Map.replace(
                        mModel,
                        "constructors",
                        mModel["constructors"] ++ [subroutineDec["object"]]
                      )

                    checkToken(
                      stream,
                      subroutineDec["index"],
                      mModel,
                      4
                    )

                  "method" ->
                    mModel =
                      Map.replace(
                        mModel,
                        "methods",
                        mModel["methods"] ++ [subroutineDec["object"]]
                      )

                    checkToken(
                      stream,
                      subroutineDec["index"],
                      mModel,
                      4
                    )

                  "function" ->
                    mModel =
                      Map.replace(
                        mModel,
                        "functions",
                        mModel["functions"] ++ [subroutineDec["object"]]
                      )

                    checkToken(
                      stream,
                      subroutineDec["index"],
                      mModel,
                      4
                    )
                end

              false ->
                IO.puts(mModel)
                {:error, "Syntax error"}
            end
        end

      100 ->
        {:ok, mModel}
    end
  end
end
