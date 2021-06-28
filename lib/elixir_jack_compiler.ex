defmodule ElixirJackCompiler.CLI do
  @moduledoc "
  Usage: elixir_jack_compiler [FLAG]... [FILE]...

  FLAGS:

  --i \t path to JACK input file
  --o \t path to XML output file (case empty, default \"build/xml\")
  "
  def main(argv) do
    argv |> parse_args() |> run
  end

  defp parse_args(args) do
    parsed_args =
      OptionParser.parse(args,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parsed_args do
      {[help: true], _, _} ->
        :help

      {[i: fileIn, o: fileOut], _, _} ->
        {:start, fileIn, fileOut}

      {[i: fileIn], _, _} ->
        {:start, fileIn}

      _ ->
        :help
    end
  end

  defp run({:start, fileIn, fileOut}) do
    Lexer.start(fileIn, fileOut)
  end

  defp run({:start, fileIn}) do
    Lexer.start(fileIn)
  end

  defp run(:help) do
    IO.puts(@moduledoc)
  end
end
