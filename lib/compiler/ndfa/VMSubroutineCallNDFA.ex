defmodule VMSubroutineCallNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "completeName" => nil,
          "expressionList" => []
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token SubroutineCall")
        subroutineName = VMSubroutineNameNDFA.checkToken(stream, index)

        cond do
          subroutineName["finished"] ->
            mModel = Map.replace(mModel, "completeName", subroutineName["object"]["name"])
            checkToken(stream, subroutineName["index"], mModel, 1)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        cond do
          tokenType == :symbol and token == "(" ->
            checkToken(stream, nextIndex, mModel, 2)

          tokenType == :symbol and token == "." ->
            checkToken(stream, nextIndex, mModel, 10)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        expressionList = VMExpressionListNDFA.checkToken(stream, index)

        cond do
          expressionList["finished"] ->
            mModel = Map.replace(mModel, "expressionList", expressionList["object"]["expressions"])

            checkToken(
              stream,
              expressionList["index"],
              mModel,
              3
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, mModel, 100)
          true -> %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      10 ->
        subroutineName = VMSubroutineNameNDFA.checkToken(stream, index)

        cond do
          subroutineName["finished"] ->
            mModel =
              Map.replace(
                mModel,
                "completeName",
                mModel["completeName"] <> "." <> subroutineName["object"]["name"]
              )

            checkToken(
              stream,
              subroutineName["index"],
              mModel,
              11
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      11 ->
        cond do
          tokenType == :symbol and token == "(" -> checkToken(stream, nextIndex, mModel, 12)
          true -> %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      12 ->
        expressionList = VMExpressionListNDFA.checkToken(stream, index)

        cond do
          expressionList["finished"] ->
            mModel = Map.replace(mModel, "expressionList", expressionList["object"]["expressions"])

            checkToken(
              stream,
              expressionList["index"],
              mModel,
              13
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      13 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, mModel, 100)
          true -> %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
