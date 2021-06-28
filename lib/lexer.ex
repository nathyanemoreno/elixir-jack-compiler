defmodule Lexer do
  def start(fileIn, fileOut) do
    # Verify if the fileIn exists
    if(!File.exists?(fileIn), do: {:badarg, "File not found."}, else: File.open!(fileIn))
    # Verify if fileOut exists, if yes delete it, else create empty one
    if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))

    # Call lexer
    {fileIn, fileOut} |> lexer(0)
    # Close files
    File.close(fileIn)
    File.close(fileOut)
  end

  def start(fileIn) do
    # Verify if the fileIn exists
    if(!File.exists?(fileIn), do: {:badarg, "File not found."}, else: File.open!(fileIn))

    # Create fileOut with fileIn basename
    fileOut = "build/xml/" <> Path.basename(fileIn, ".jack") <> ".xml"
    if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))

    # Call lexer
    {fileIn, fileOut} |> lexer(0)
    File.close(fileIn)
    File.close(fileOut)
  end

  def lexer({fileIn, fileOut}, initialIndex) do
    stream = File.read!(fileIn)
    # Get token info from DFA
    tokenObj = stream |> Token.getToken(initialIndex)

    # Write first tag <token/>
    if(initialIndex == 0, do: File.write!(fileOut, "<tokens>\n", [:append]))

    # Verify if token is nil (\0) or if not EOF
    if(tokenObj == nil and tokenObj["index"] >= String.length(stream)) do
      File.write!(fileOut, "</tokens>", [:append])
    else
      # Write xml tag on fileOut
      tokenObj |> xmler(fileOut)
      # Recall lexer with last index returned
      lexer({fileIn, fileOut}, tokenObj["index"])
    end
  end

  def xmler(tokenObj, fileOut) do
    tag = "<#{tokenObj["type"]}> #{tokenObj["token"]} </#{tokenObj["type"]}>\n"
    File.write!(fileOut, tag, [:append])
  end
end
