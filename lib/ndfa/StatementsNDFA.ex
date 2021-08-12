defmodule StatementsNDFA do
  def checkToken(stream, xml_carry, index \\ 0, tokenState \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextIndex = tokenObj["index"]

    case tokenState do
      0 ->
        IO.inspect("Checking token Statements")
        # * Go to state 100
        statement = StatementNDFA.checkToken(stream, "", index)

        cond do
          statement["finished"] -> checkToken(stream, xml_carry , statement["index"], 0)
          true -> checkToken(stream, xml_carry, statement["index"], 100)
        end

      100 ->
        IO.puts(">> Exiting StatementsNDFA (SUCCESS)")
        %{"finished" => true, "index" => index, "token" => token, "xml" => "<statements>" <> xml_carry <> "\n</statements>"}
    end
  end
end
