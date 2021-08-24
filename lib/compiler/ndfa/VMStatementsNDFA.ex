defmodule VMStatementsNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "statements" => []
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token Statements")
        # * Go to state 100
        statement = VMStatementNDFA.checkToken(stream, index)

        cond do
          statement["finished"] ->
            mModel =
              Map.replace(mModel, "statements", mModel["statements"] ++ [statement["object"]])

            checkToken(stream, statement["index"], mModel, 0)

          true ->
            checkToken(stream, statement["index"], mModel, 100)
        end

      100 ->
        IO.puts(">> Exiting StatementsNDFA (SUCCESS)")

        %{
          "finished" => true,
          "index" => index,
          "token" => token,
          "object" => mModel
        }
    end
  end
end
