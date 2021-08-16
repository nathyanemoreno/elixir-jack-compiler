defmodule Syntaxer do
  def start(fileIn) do
    try do
      # * Create fileOut with fileIn basename
      # filePath = "build/xml/syntax/" <> Path.basename(fileIn, ".jack") <> ".xml"

      case File.read(fileIn) do
        {:ok, stream} ->
          case SyntaxerNDFA.checkToken(stream) do
            {:ok, message} ->
              # * Can go to compilation phase
              # fileOut = Xmler.run(:syntaxer, filePath, syntaxResult)
              Syntax.success("No errors")
              {:ok, :compile}

            {:error, token} ->
              Syntax.unexpectedToken(token)
          end

        {:error, :enoent} ->
          Syntax.error("Unable to read #{fileIn}")
      end
    after
      File.close(fileIn)
      {:ok, :compile}
    end
  end

  def start(fileIn, filePath) do
    try do
      case File.read(fileIn) do
        {:ok, stream} ->
          {:ok, syntaxResult} = SyntaxerNDFA.checkToken(stream)
          # * Can go to compilation phase
          {:ok, :compile}
          # fileOut = Xmler.run(:syntaxer, filePath, syntaxResult)
          # Syntax.success("Compilation of file #{fileIn} to #{fileOut}")

        {:error, :enoent} ->
          Syntax.error("Unable to read #{fileIn}")
      end
    after
      File.close(fileIn)
      {:ok, :compile}
    end
  end
end
