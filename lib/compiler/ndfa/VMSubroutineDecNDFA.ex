defmodule VMSubroutineDecNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "kind" => nil,
          "returnType" => nil,
          "subroutineName" => nil,
          "varDecs" => [],
          "statements" => [],
          "parameters" => []
        },
        state \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]

    case state do
      # Read: keyword
      0 ->
        IO.puts("Checking token in SubroutineDec")

        cond do
          tokenType == :keyword and
              (token == "constructor" or token == "function" or token == "method") ->
            mModel = Map.replace(mModel, "kind", token)
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        cond do
          tokenType == :keyword and token == "void" ->
            checkToken(stream, nextIndex, mModel, 2)

          true ->
            type = VMTypeNDFA.checkToken(stream, index)

            cond do
              type["finished"] ->
                mModel = Map.replace(mModel, "returnType", type["object"]["name"])
                checkToken(stream, type["index"], mModel, 2)

              true ->
                %{"finished" => false, "index" => index, "token" => token, "object" => ""}
            end
        end

      2 ->
        subroutineName = VMSubroutineNameNDFA.checkToken(stream, index)

        cond do
          subroutineName["finished"] ->
            mModel = Map.replace(mModel, "subroutineName", subroutineName["object"]["name"])

            checkToken(
              stream,
              subroutineName["index"],
              mModel,
              3
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      3 ->
        cond do
          tokenType == :symbol and token == "(" ->
            checkToken(stream, nextIndex, mModel, 4)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      4 ->
        parameterList = VMParameterListNDFA.checkToken(stream, index)

        cond do
          parameterList["finished"] ->
            mModel = Map.replace(mModel, "parameters", parameterList["object"]["parameters"])

            checkToken(
              stream,
              parameterList["index"],
              mModel,
              5
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      5 ->
        cond do
          tokenType == :symbol and token == ")" ->
            checkToken(stream, nextIndex, mModel, 6)

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      6 ->
        subroutineBody = VMSubroutineBodyNDFA.checkToken(stream, index)

        cond do
          subroutineBody["finished"] ->
            mModel = Map.replace(mModel, "statements", subroutineBody["object"]["statements"])
            mModel = Map.replace(mModel, "varDecs", subroutineBody["object"]["varDecs"])

            checkToken(
              stream,
              subroutineBody["index"],
              mModel,
              100
            )

          true ->
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
