defmodule VMClassNameNDFA do
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
    # IO.inspect(tokenObj)

    case state do
      0 ->
        IO.inspect(
          "Checking token in ClassName " <> "--------------------> " <> tokenObj["token"]
        )

        case tokenType do
          :identifier ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          _ ->
            IO.puts(">> Exiting ClassNameNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting ClassNameNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
