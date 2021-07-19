defmodule Syntaxer do
  def start(fileIn) do
    stream = File.read!(fileIn)
    SyntaxerDFA.checkToken(stream)
  end

  def start(fileIn, fileOut) do
    token = Lexer.start(fileIn, fileOut)
  end

end
