defmodule Syntaxer do
  def start(fileIn) do
    stream = File.read!(fileIn)
    syntaxResult = SyntaxerNDFA.checkToken(stream, "")

    if(File.exists?(fileIn)) do
      File.open!(fileIn)
      # Create fileOut with fileIn basename
      fileOut = "build/xml/syntax/" <> Path.basename(fileIn, ".jack") <> ".xml"
      if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))

      # Write xml
      xmler(fileOut, syntaxResult)

      File.close(fileIn)
      File.close(fileOut)
    else
      IO.puts(IO.ANSI.format(IO.ANSI.red() <> "\nFile #{fileIn} not found." <> IO.ANSI.reset()))
      {:error, "File not found."}
    end
  end

  def xmler(fileOut, string) do
    File.write!(fileOut, string)
  end
end
