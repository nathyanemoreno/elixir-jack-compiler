defmodule Lexer do
  def start(fileIn, fileOut) do
    if(!File.exists?(fileIn), do: {:badarg, "File not found."}, else: File.open!(fileIn))
    if(File.exists?(fileOut), do: File.rm!(fileOut), else: File.write!(fileOut, ""))
    {fileIn, fileOut} |> lexer(0)
  end

  def lexer({fileIn, fileOut}, initialIndex) do
    fileName = File.read!(fileIn)
    tokenObj = fileName |> Token.getToken(initialIndex)
    if(initialIndex == 0, do: File.write!(fileOut, "<tokens>\n", [:append]))

    if(tokenObj == nil and tokenObj["index"] >= String.length(fileName)) do
      File.write!(fileOut, "</tokens>", [:append])
    else
      tokenObj |> getTag() |> writeXML(fileOut)
      lexer({fileIn, fileOut}, tokenObj["index"])
    end
  end

  def getTag(tokenObj), do: "<#{tokenObj["type"]}> #{tokenObj["token"]} </#{tokenObj["type"]}>\n"

  def writeXML(tag, fileOut), do: File.write!(fileOut, tag, [:append])

  def readFileLine(filePath), do: File.open(filePath, [:read, :compressed]) |> IO.read(:line)
end
