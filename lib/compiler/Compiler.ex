defmodule Compiler do
  def start(path) do
    files = get_files(path)

    stream_out = Compiler.build(files)
    File.write!("data/vm/VMFile.vm", stream_out)
    IO.inspect(stream_out)
  end

  def start(fileIn, fileOut) do
    {:ok, message} = Syntaxer.start(fileIn)
  end

  def get_files(path) do
    {:ok, files} = File.ls(path)
    files = Path.wildcard(path <> "*.jack")
    if(Enum.empty?(files), do: CompilerMessages.error("No .jack files in #{path}"), else: files)
  end

  def build(files, fileContent \\ "") do
    if(!Enum.empty?(files)) do
      [file | tail] = files
      stream = File.read!(file)
      {message, fileClassObject} = VMClassDefNDFA.checkToken(stream)
      IO.inspect(fileClassObject)

      fileOut = build_class(fileClassObject)
      # IO.puts(fileContent)
      build(tail, fileContent <> fileOut)
    else
      fileContent
    end
  end

  def build_class(classObject) do
    vars = get_vars()
    vars = Map.replace(vars, "fields", classObject["fields"])
    vars = Map.replace(vars, "statics", classObject["statics"])

    vmContent = ""

    vmContent =
      vmContent <>
        build_subroutines_functions(classObject["className"], classObject["functions"], vars) <>
        build_subroutines_methods(classObject["className"], classObject["methods"], vars) <>
        build_subroutines_constructors(
          classObject["className"],
          classObject["constructors"],
          vars
        )

    # vmContent = vmContent <> build_subroutines_methods(classObject["methods"], vars)
    # vmContent = vmContent <> build_subroutines_constructors(classObject["constructors"], vars)
    vmContent
  end

  def count_locals(locals, index1 \\ 0, index2 \\ 0) do
    localGroup = Enum.at(locals, index1)

    case localGroup do
      nil ->
        0

      _ ->
        local = Enum.at(localGroup["varNames"], index2)

        case local do
          nil ->
            count_locals(locals, 1 + index1)

          _ ->
            IO.inspect(local)
            1 + count_locals(locals, index1, 1 + index2)
        end
    end
  end

  def build_subroutines_functions(className, functions, vars, index \\ 0) do
    item = Enum.at(functions, index)

    case item do
      nil ->
        ""

      _ ->
        fvars = Map.replace(vars, "locals", item["varDecs"])
        fvars = Map.replace(fvars, "arguments", item["parameters"])

        "function " <>
          className <>
          "." <>
          item["subroutineName"] <>
          " " <>
          Integer.to_string(count_locals(item["varDecs"])) <>
          "\n" <>
          build_statements(item["statements"], fvars) <>
          build_subroutines_functions(className, functions, vars, 1 + index)
    end
  end

  def build_subroutines_methods(className, methods, vars, index \\ 0) do
    item = Enum.at(methods, index)

    case item do
      nil ->
        ""

      _ ->
        fvars = Map.replace(vars, "locals", item["varDecs"])
        fvars = Map.replace(fvars, "arguments", item["parameters"])

        "function " <>
          className <>
          "." <>
          item["subroutineName"] <>
          " " <>
          Integer.to_string(count_locals(item["varDecs"])) <>
          "\npush argument 0\npop pointer 0\n" <>
          build_statements(item["statements"], fvars) <>
          build_subroutines_methods(className, methods, vars, 1 + index)
    end
  end

  def build_subroutines_constructors(className, constructors, vars, index \\ 0) do
    item = Enum.at(constructors, index)

    case item do
      nil ->
        ""

      _ ->
        fvars = Map.replace(vars, "locals", item["varDecs"])
        fvars = Map.replace(fvars, "arguments", item["parameters"])

        "function " <>
          className <>
          "." <>
          item["subroutineName"] <>
          " " <>
          Integer.to_string(count_locals(item["varDecs"])) <>
          "\n" <>
          build_statements(item["statements"], fvars) <>
          build_subroutines_constructors(className, constructors, vars, 1 + index)
    end
  end

  def build_statements(statements, vars, index \\ 0) do
    statement = Enum.at(statements, index)
    IO.puts("Building statment:")
    IO.inspect(statement)
    IO.puts("----------------------")

    case statement do
      nil ->
        ""

      _ ->
        case statement["kind"] do
          "do" ->
            build_do(statement["statement"], vars) <>
              build_statements(statements, vars, 1 + index)

          "let" ->
            build_let(statement["statement"], vars) <>
              build_statements(statements, vars, 1 + index)

          "while" ->
            build_while(statement["statement"], vars, index) <>
              build_statements(statements, vars, 1 + index)

          "if" ->
            build_if(statement["statement"], vars, index) <>
              build_statements(statements, vars, 1 + index)

          "return" ->
            build_return(statement["statement"], vars) <>
              build_statements(statements, vars, 1 + index)

          _ ->
            nil
        end
    end
  end

  def build_do(doStatement, vars) do
    subroutineCall = doStatement["subroutineCall"]

    build_subroutineCall(subroutineCall, vars, true) <> "pop temp 0\n"
  end

  def build_expressionList(expressions, vars, index \\ 0) do
    expression = Enum.at(expressions, index)

    case expression do
      nil ->
        ""

      _ ->
        build_expression(expression, vars) <>
          build_expressionList(expressions, vars, 1 + index)
    end
  end

  @spec build_expression(any, any, integer, any) :: binary
  def build_expression(expression, vars, index \\ 0, ops \\ []) do
    chunk = Enum.at(expression, index)
    IO.puts("---------------------------------")
    IO.inspect(expression)

    case chunk do
      nil ->
        pop_ops(ops)

      _ ->
        case rem(index, 2) === 0 do
          true ->
            # Terms
            build_expression_term(chunk, vars) <>
              build_expression(expression, vars, 1 + index, ops)

          false ->
            # Ops
            build_expression(expression, vars, 1 + index, ops ++ [build_expression_op(chunk)])
        end
    end
  end

  def build_while(whileStatement, vars, index \\ 0) do
    statement = whileStatement["expression"]
    statements = whileStatement["statements"]

    case statement do
      nil ->
        "return\n"

      _ ->
        "label WHILE_EXP#{index}\n" <>
          build_expression(statement, vars) <>
          "not\n" <>
          "if-goto WHILE_END#{index}\n" <>
          build_statements(statements, vars) <>
          "goto WHILE_EXP#{index}\n" <>
          "label WHILE_END#{index}\n"
    end
  end

  def build_if(ifStatement, vars, index \\ 0) do
    expression = ifStatement["expression"]
    statements = ifStatement["statements"]
    elseStatements = ifStatement["elseStatements"]

    case statements do
      nil ->
        ""

      _ ->
        case elseStatements do
          nil ->
            build_expression(expression, vars) <>
              "if-goto IF_TRUE#{index}\ngoto IF_END#{index}\nlabel IF_TRUE#{index}\n" <>
              build_statements(statements, vars) <>
              "goto IF_END#{index}\nlabel IF_END#{index}\n"

          _ ->
            build_expression(expression, vars) <>
              "if-goto IF_TRUE#{index}\ngoto IF_FALSE#{index}\nlabel IF_TRUE#{index}\n" <>
              build_statements(statements, vars) <>
              "goto IF_END#{index}\nlabel IF_FALSE#{index}\n" <>
              build_statements(elseStatements, vars) <>
              "label IF_END#{index}\n"
        end
    end
  end

  def build_expression_term(term, vars) do
    case term["kind"] do
      :expression ->
        build_expression(term["term"], vars)

      :variable ->
        "push " <> get_var_scope_index(term["term"], vars, :local) <> "\n"

      :integerConstant ->
        "push constant " <> term["term"] <> "\n"

      :subroutineCall ->
        build_subroutineCall(term["term"], vars)

      :keywordConstant ->
        "push constant " <> "0" <> "\n"

      :unaryTerm ->
        build_unary_term(term["term"], vars)
    end
  end

  def build_unary_term(unary_term, vars) do
    unaryOp = Enum.at(unary_term, 0)

    case unaryOp["operator"] do
      "~" -> build_expression_term(Enum.at(unary_term, 1), vars) <> "not\n"
      "-" -> build_expression_term(Enum.at(unary_term, 1), vars) <> "neg\n"
    end
  end

  def build_subroutineCall(subroutineCall, vars, isDoStatment \\ false) do
    case isDoStatment do
      true ->
        build_expressionList(subroutineCall["expressionList"], vars) <>
          "call " <>
          subroutineCall["completeName"] <>
          " " <> Integer.to_string(Enum.count(subroutineCall["expressionList"])) <> "\n"

      false ->
        build_expressionList(subroutineCall["expressionList"], vars) <>
          "call " <>
          subroutineCall["completeName"] <>
          " " <> Integer.to_string(1 + Enum.count(subroutineCall["expressionList"])) <> "\n"
    end
  end

  def build_expression_op(op) do
    case op["operator"] do
      "+" -> "add\n"
      "-" -> "sub\n"
      "/" -> "div\n"
      "*" -> "call Math.multiply 2\n"
      "<" -> "lt\n"
      ">" -> "gt\n"
      "=" -> "eq\n"
    end
  end

  def pop_ops(ops, index \\ 0) do
    op = Enum.at(ops, index)

    case op do
      nil ->
        case index == 0 do
          true ->
            ""

          false ->
            pop_ops_reverse(ops, index - 1)
        end

      _ ->
        pop_ops(ops, 1 + index)
    end
  end

  def pop_ops_reverse(ops, index) do
    case index == -1 do
      true ->
        ""

      _ ->
        op = Enum.at(ops, index)
        Enum.at(ops, index) <> pop_ops_reverse(ops, index - 1)
    end
  end

  def build_let(letStatement, vars) do
    varName = letStatement["varName"]
    expression = letStatement["expression"]

    IO.puts("Vars:")
    IO.inspect(vars)
    IO.puts("--------------------------------")

    var = get_var_scope_index(varName, vars, :local)

    case var do
      nil ->
        CompilerMessages.error("Variable #{varName} does not exists")

      _ ->
        build_expression(expression, vars) <>
          "pop " <> var <> "\n"
    end
  end

  def build_return(returnStatement, vars) do
    expression = returnStatement["expression"]

    case expression do
      nil ->
        "push constant 0\nreturn\n"

      _ ->
        build_expression(expression, vars) <> "return\n"
    end
  end

  def get_vars() do
    %{"locals" => [], "arguments" => [], "fields" => [], "statics" => []}
  end

  def get_var_scope_index(
        varName,
        vars,
        currentType,
        listIndex \\ 0,
        subitemIndex \\ 0,
        overallIndex \\ 0
      ) do
    case currentType do
      :local ->
        item = Enum.at(vars["locals"], listIndex)

        case item do
          nil ->
            get_var_scope_index(varName, vars, :argument)

          _ ->
            subitem = Enum.at(item["varNames"], subitemIndex)

            case subitem do
              nil ->
                get_var_scope_index(varName, vars, :local, 1 + listIndex, 0, overallIndex)

              _ ->
                case subitem == varName do
                  true ->
                    "local " <> Integer.to_string(overallIndex)

                  false ->
                    get_var_scope_index(
                      varName,
                      vars,
                      :local,
                      listIndex,
                      1 + subitemIndex,
                      1 + overallIndex
                    )
                end
            end
        end

      :argument ->
        item = Enum.at(vars["arguments"], listIndex)

        case item do
          nil ->
            get_var_scope_index(varName, vars, :field)

          _ ->
            case item["varName"] == varName do
              true ->
                "argument " <> Integer.to_string(overallIndex)

              false ->
                get_var_scope_index(varName, vars, :argument, 1 + listIndex, 0, 1 + overallIndex)
            end
        end

      :field ->
        IO.inspect(vars)
        item = Enum.at(vars["fields"], listIndex)

        case item do
          nil ->
            get_var_scope_index(varName, vars, :static)

          _ ->
            subitem = Enum.at(item["varNames"], subitemIndex)

            case subitem do
              nil ->
                get_var_scope_index(varName, vars, :field, 1 + listIndex, 0, overallIndex)

              _ ->
                case subitem == varName do
                  true ->
                    "field " <> Integer.to_string(overallIndex)

                  false ->
                    get_var_scope_index(
                      varName,
                      vars,
                      :field,
                      listIndex,
                      1 + subitemIndex,
                      1 + overallIndex
                    )
                end
            end
        end

      :static ->
        item = Enum.at(vars["statics"], listIndex)

        case item do
          nil ->
            nil

          _ ->
            subitem = Enum.at(item["varNames"], subitemIndex)

            case subitem do
              nil ->
                get_var_scope_index(varName, vars, :static, 1 + listIndex, 0, overallIndex)

              _ ->
                case subitem == varName do
                  true ->
                    "static " <> Integer.to_string(overallIndex)

                  false ->
                    get_var_scope_index(
                      varName,
                      vars,
                      :static,
                      listIndex,
                      1 + subitemIndex,
                      1 + overallIndex
                    )
                end
            end
        end
    end
  end
end
