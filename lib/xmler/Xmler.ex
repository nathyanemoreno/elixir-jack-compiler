defmodule Xmler do
  def run({fileIn, fileOut}, initialIndex \\ 0) do
    stream = File.read!(fileIn)
    # Get token info from DFA
    tokenObj = stream |> Token.getToken(initialIndex)

    # Write first tag <token/>
    if(initialIndex == 0, do: File.write!(fileOut, "<tokens>\n", [:append]))

    # Verify if token is nil (\0) or if not EOF
    if(tokenObj == nil and tokenObj["index"] >= String.length(stream)) do
      File.write!(fileOut, "</tokens>", [:append])
      {:ok, IO.ANSI.format("\nThe .xml file was saved in " <> IO.ANSI.yellow() <> fileOut <> IO.ANSI.reset())}
    else
      # Write xml tag on fileOut
      tokenObj |> writeTag(fileOut)
      # Recall lexer with last index returned
      run({fileIn, fileOut}, tokenObj["index"])
    end
  end

  def writeTag(tokenObj, fileOut) do
    tag = "<#{tokenObj["type"]}> #{tokenObj["token"]} </#{tokenObj["type"]}>\n"
    File.write!(fileOut, tag, [:append])
  end
end
