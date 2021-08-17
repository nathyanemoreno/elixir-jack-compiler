defmodule VMVarNameNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "name" => nil
        },
        tokenState \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]
    # IO.inspect(tokenObj)

    case tokenState do
      0 ->
        IO.puts("Checking token in VarName")

        cond do
          # * If identifier get next
          tokenType == :identifier ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting VarNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting VarNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
