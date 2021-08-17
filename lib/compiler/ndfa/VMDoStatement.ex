defmodule VMDoStatementNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "subroutineCall" => nil
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token DoStatementNDFA")

        cond do
          # * Go to state 1
          tokenType == :keyword and token == "do" ->
            checkToken(stream, nextIndex, mModel, 1)

          true ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      1 ->
        subroutineCall = VMSubroutineCallNDFA.checkToken(stream, index)

        case subroutineCall["finished"] do
          true ->
            mModel = Map.replace(mModel, "subroutineCall", subroutineCall["object"])

            checkToken(
              stream,
              subroutineCall["index"],
              mModel,
              2
            )

          false ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      2 ->
        cond do
          # * Go to state 1
          tokenType == :symbol and token == ";" ->
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting DoStatementNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting DoStatementNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
