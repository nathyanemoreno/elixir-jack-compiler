defmodule ExpressionNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]


    case tokenState do
      0 ->
        IO.puts("Checking token Expression")
        term = TermNDFA.checkToken(stream, "", index)
        cond do
          term["finished"] -> checkToken(stream,"", term["index"], 1)
          true ->
            IO.puts(">> Exiting ExpressionNDFA (FAILED)")
            %{"finished" => false, "index" => index, "token" => token}
        end
      1 ->
        op = OperatorNDFA.checkToken(stream, "", index)
        cond do
          op["finished"] -> checkToken(stream, xml_carry , op["index"], 2)
          true -> checkToken(stream, xml_carry, index, 100)
        end
      2 ->
        term = TermNDFA.checkToken(stream, "", index)
        cond do
          term["finished"] -> checkToken(stream, xml_carry , term["index"], 1)
          true -> checkToken(stream, xml_carry, index, 100)
        end
      100 ->
        IO.puts(">> Exiting ExpressionNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<expression>\n" <> xml_carry <> "\n</expression>"}
    end
  end
end
