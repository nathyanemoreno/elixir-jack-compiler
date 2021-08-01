defmodule Syntax do
  def unexpectedToken(message \\ "Error") do
    # IO.puts("[SyntaxError] Too bad.")
    IO.puts(IO.ANSI.magenta() <> "Unexpected token: " <> message <> IO.ANSI.reset())
  end

  def alert(message \\ "Warnig") do
    IO.puts(IO.ANSI.yellow() <> "Alert: " <> message  <> IO.ANSI.reset())
  end

  def success(message \\ "Success") do
    IO.puts(IO.ANSI.green() <> "\nSucess: " <> message <> IO.ANSI.reset())
  end

  def error(message \\ "Error") do
    IO.puts(IO.ANSI.red() <> "\nError: " <> message  <> IO.ANSI.reset())
  end

  def message(message \\ "Message") do
    IO.puts(IO.ANSI.cyan() <> "\nMessage: " <> message <> IO.ANSI.reset())
  end
end
