defmodule Char do
  def isValid(string) do
    <<char::utf8>> = string

    cond do
      char > 47 and char < 58 -> true
      char > 64 and char < 91 -> true
      char == 95 -> true
      char > 96 and char < 123 -> true
      true -> false
    end
  end

  def isNumber(string) do
    <<char::utf8>> = string
    if(char > 47 and char < 58, do: true, else: false)
  end
end
