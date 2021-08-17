defmodule VMSubroutineNameNDFA do
  def checkToken(
        stream,
        index,
        mModel \\ %{
          "name" => nil
        },
        state \\ 0
      ) do
    tokenObj = Lexer.lexer(stream, index)
    tokenType = tokenObj["type"]
    token = tokenObj["token"]
    nextIndex = tokenObj["index"]

    case state do
      0 ->
        IO.puts("Checking token in SubroutineNameNDFA")

        cond do
          # * If identifier get next
          tokenType == :identifier ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            IO.puts(">> Exiting SubroutineNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting SubroutineNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
