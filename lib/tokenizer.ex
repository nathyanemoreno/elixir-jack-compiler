defmodule Tokenizer do
  def     tokenType(tk) do
    cond do
      TokenType.keywords[tk] -> :keyword
    end
  end
end
