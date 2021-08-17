defmodule VMTypeNDFA do
  def checkToken(stream, index, mModel \\ %{"name" => nil}, state \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case state do
      # Read: keyword
      0 ->
        IO.inspect("Checking token in Type")

        cond do
          tokenType == :keyword and token == "int" ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          tokenType == :keyword and token == "char" ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          tokenType == :keyword and token == "boolean" ->
            mModel = Map.replace(mModel, "name", token)
            checkToken(stream, nextIndex, mModel, 100)

          true ->
            className = VMClassNameNDFA.checkToken(stream, index)

            cond do
              className["finished"] ->
                mModel = Map.replace(mModel, "name", className["object"]["name"])
                checkToken(stream, className["index"], mModel, 100)

              true ->
                IO.puts(">> Exiting TypeNDFA (FAILED)")
                %{"finished" => false, "index" => index, "token" => token, "object" => ""}
            end
        end

      100 ->
        IO.puts(">> Exiting TypeNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
