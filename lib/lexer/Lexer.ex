defmodule Lexer do
  def start(fileIn, fileOut) do
    # Verify if the fileIn exists
    if(!File.exists?(fileIn), do: {:badarg, "File not found."}, else: File.open!(fileIn))
    # Verify if fileOut exists, if yes delete it, else create empty one
    if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))

    # Call lexer
    {fileIn, fileOut} |> Xmler.run()
    # Close files
    File.close(fileIn)
    File.close(fileOut)
  end

  def start(fileIn) do
    # Verify if the fileIn exists
    if(File.exists?(fileIn)) do
      File.open!(fileIn)
      # Create fileOut with fileIn basename
      fileOut = "build/xml/" <> Path.basename(fileIn, ".jack") <> ".xml"
      if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))

      # Call lexer
      {:ok, finish} = {fileIn, fileOut} |> Xmler.run()
      IO.puts(finish)

      File.close(fileIn)
      File.close(fileOut)
    else
      IO.puts(IO.ANSI.format(IO.ANSI.red() <> "\nFile #{fileIn} not found." <> IO.ANSI.reset()))
      {:error, "File not found."}
    end
  end

  def lexer(stream, initialIndex \\ 0) do
    # Get token info from DFA
    tokenObj = stream |> Token.getToken(initialIndex)
    cond do
      tokenObj != nil ->
        IO.puts("Peek ---> " <> tokenObj["token"])
        tokenObj
      true -> tokenObj
    end
  end

end
