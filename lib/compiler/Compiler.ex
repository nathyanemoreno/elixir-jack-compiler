defmodule Compiler do
  def start(fileIn) do
    {:ok, message} = Syntaxer.start(fileIn)

    if(message == :compile) do
      stream = File.read!(fileIn)
      tokenObj = Compiler.build(stream)
    end
  end

  def start(fileIn, fileOut) do
    {:ok, message} = Syntaxer.start(fileIn)
  end

  def build(stream) do
    buildClass(stream)
  end

  def buildClass(stream, index \\ 0) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    nextToken = tokenObj["index"]
    tokenType = tokenObj["type"]

    IO.puts("Check class --> " <> token)

    cond do
      token == nil ->
        true

      token == "{" ->
        {declarations, nextToken} = buildDeclarations(stream, nextToken)
        # IO.inspect(declarations)
        methods = buildFunctions(stream, nextToken, declarations)

      # pile |> Enum.with_index() |> Enum.each(fn {v, i} -> push(Enum.at(kind, i), i) end)

      token == "class" or tokenType == :identifier or true ->
        buildClass(stream, nextToken)
    end
  end

  def buildDeclarations(stream, index \\ 0, pile \\ [%{"name" => "", "kind" => "", "type" => ""}]) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextToken = tokenObj["index"]

    # IO.inspect(token)

    IO.puts("Check declaration " <> token)

    cond do
      token == "field" or token == "static" ->
        [head | tail] = pile
        row = Map.replace(head, "kind", token)
        buildDeclarations(stream, nextToken, [row] ++ tail)

      token == "," ->
        [head | tail] = pile
        row = Map.replace(head, "name", "")
        buildDeclarations(stream, nextToken, [row] ++ pile)

      tokenType == :identifier ->
        [head | tail] = pile
        row = Map.replace(head, "name", token)
        row = Map.replace(row, "type", tokenType)
        buildDeclarations(stream, nextToken, [row] ++ tail)

      # * Duplicates the last row
      token == ";" ->
        [head | tail] = pile
        buildDeclarations(stream, nextToken, [head] ++ pile)

      token == "constructor" or token == "method" or token == "}" ->
        [head | tail] = pile
        # buildFunctions(stream, tail, nextToken)
        {pile, nextToken}

      true ->
        buildDeclarations(stream, nextToken, pile)
    end
  end

  def buildFunctions(stream, index \\ 0, pile \\ [%{"name" => "", "kind" => "", "type" => ""}]) do
    # IO.inspect(kind)
    # IO.inspect(pile)
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    nextToken = tokenObj["index"]
    tokenType = tokenObj["type"]

    cond do
      tokenType == :identifier ->
        IO.puts("Check function " <> token)
        [head | tail] = pile
        row = Map.replace(head, "name", token)
        row = Map.replace(row, "type", "local")
        IO.inspect([row] ++ tail)
        buildFunctions(stream, nextToken, [row] ++ tail)

      token == "var" ->
        [head | tail] = pile

        row = Map.replace(head, "kind", token)
        # IO.inspect(row)
        buildFunctions(stream, nextToken, [row] ++ tail)

      token == "(" ->
        [head | tail] = pile
        row = Map.replace(head, "name", "")
        {arguments, nextToken} = buildArguments(stream, nextToken, [row] ++ pile)
        # * Duplicates the last row
        [head | tail] = arguments
        buildFunctions(stream, nextToken, [head] ++ arguments)

      token == "," ->
        [head | tail] = pile
        row = Map.replace(head, "name", "")
        buildFunctions(stream, nextToken, [row] ++ pile)

      token == ";" ->
        [head | tail] = pile
        buildFunctions(stream, nextToken, [head] ++ pile)

      token == "method" or token == "}" ->
        [head | tail] = pile
        {pile, nextToken}

      # token == ";" or token == "method" or tokenType == :identifier or true ->
      #   buildFunctions(stream, pile, nextToken)

      true ->
        buildFunctions(stream, nextToken, pile)
    end
  end

  def buildArguments(stream, index \\ 0, pile \\ [%{"name" => "", "kind" => "", "type" => ""}]) do
    tokenObj = Lexer.lexer(stream, index)
    token = tokenObj["token"]
    tokenType = tokenObj["type"]
    nextToken = tokenObj["index"]

    cond do
      tokenType == :keyword ->
        [head | tail] = pile
        row = Map.replace(head, "kind", "argument")
        row = Map.replace(row, "type", token)
        buildArguments(stream, nextToken, [row] ++ tail)

      tokenType == :identifier ->
        IO.puts("Check argument " <> token)
        [head | tail] = pile
        row = Map.replace(head, "name", token)
        buildArguments(stream, nextToken, [row] ++ tail)

      token == "," ->
        [head | tail] = pile
        row = Map.replace(head, "name", "")
        buildArguments(stream, nextToken, [row] ++ pile)

      token == ")" ->
        {pile, nextToken}

      true ->
        buildArguments(stream, nextToken, pile)
    end
  end

  def push(kind, pos) do
    IO.puts(
      IO.ANSI.blue() <>
        "push " <>
        IO.ANSI.magenta() <>
        kind <> " " <> IO.ANSI.white() <> Integer.to_string(pos) <> IO.ANSI.reset()
    )
  end
end
