defmodule VMKeywordConstantNDFA do
  def checkToken(stream, index, mModel \\ %{"name" => nil}, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token KeywordConstant")

        cond do
          tokenType == :keyword and token == "true" ->
            checkToken(stream, nextIndex, %{"name" => "true"}, 100)

          tokenType == :keyword and token == "false" ->
            checkToken(stream, nextIndex, %{"name" => "false"}, 100)

          tokenType == :keyword and token == "null" ->
            checkToken(stream, nextIndex, %{"name" => "null"}, 100)

          tokenType == :keyword and token == "this" ->
            checkToken(stream, nextIndex, %{"name" => "this"}, 100)

          true ->
            IO.puts(">> Exiting KeywordConstantNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token, "object" => ""}
        end

      100 ->
        IO.puts(">> Exiting KeywordConstantNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "object" => mModel}
    end
  end
end
