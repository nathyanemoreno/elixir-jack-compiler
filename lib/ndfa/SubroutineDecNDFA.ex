defmodule SubroutineDecNDFA do
  def checkToken(stream, index, state \\ 0) do
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
            checkToken(stream, nextIndex, 1)

          true ->
            %{"finished" => false, "index" => index, "token" => token}
        end

      1 ->
        cond do
          tokenType == :keyword and token == "void" -> checkToken(stream, nextIndex, 2)
          true ->
            type = TypeNDFA.checkToken(stream, index)

            cond do
              type["finished"] -> checkToken(stream, type["index"], 2)
              true -> %{"finished" => false, "index" => index, "token" => token}
            end
        end
      2 ->
        subroutineName = SubroutineNameNDFA.checkToken(stream, index)
        cond do
          subroutineName["finished"] -> checkToken(stream, subroutineName["index"], 3)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      3 ->
        cond do
          tokenType == :symbol and token == "(" -> checkToken(stream, nextIndex, 4)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      4 ->
        parameterList = ParameterListNDFA.checkToken(stream, index)
        cond do
          parameterList["finished"] -> checkToken(stream, parameterList["index"], 5)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
        5 ->
        cond do
          tokenType == :symbol and token == ")" -> checkToken(stream, nextIndex, 6)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      6 ->
        subroutineBody = SubroutineBodyNDFA.checkToken(stream, index)
        cond do
          subroutineBody["finished"] -> checkToken(stream, subroutineBody["index"], 100)
          true -> %{"finished" => false, "index" => index, "token" => token}
        end
      100 ->
        %{"finished" => true, "index" => index, "token" => token}
    end
  end
end
