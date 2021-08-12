defmodule Compiler do
  def start(fileIn) do
    {:ok, message} = Syntaxer.start(fileIn)

    if(message == :no_error) do
    end
  end

  def start(fileIn, fileOut) do
    {:ok, message} = Syntaxer.start(fileIn)
  end
end
