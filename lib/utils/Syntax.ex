defmodule Syntax do
  def unexpectedToken(message \\ "Error") do
    IO.puts(IO.ANSI.red <> "Unexpected token: "<> message  <> IO.ANSI.reset)
  end
end
