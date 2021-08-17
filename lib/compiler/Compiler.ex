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
    {:ok, fileClassObject} = VMClassDefNDFA.checkToken(stream)
    IO.inspect(fileClassObject)

    fileContent = build_class(fileClassObject)
    IO.puts(fileContent)
    fileContent
  end

  @spec build_class(nil | maybe_improper_list | map) :: binary
  def build_class(classObject) do
    vars = get_vars()
    vars = Map.replace(vars, "fields", classObject["fields"])
    vars = Map.replace(vars, "statics", classObject["statics"])

    vmContent = ""

    vmContent =
      vmContent <>
        build_subroutines_functions(classObject["className"], classObject["functions"], vars)

    # vmContent = vmContent <> build_subroutines_methods(classObject["methods"], vars)
    # vmContent = vmContent <> build_subroutines_constructors(classObject["constructors"], vars)
    vmContent
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
          Integer.to_string(Enum.count(item["parameters"])) <>
          "\n" <>
          build_statments(item["statments"], fvars) <>
          build_subroutines_functions(className, functions, vars, 1 + index)
    end
  end

  def build_statments(statments, vars, index \\ 0) do
    statment = Enum.at(statments, index)

    case statment do
      nil ->
        ""

      _ ->
        case statment["kind"] do
          "do" ->
            build_do(statment["statment"], vars) <>
              build_statments(statments, vars, 1 + index)

          "let" ->
            build_let(statment["statment"], vars) <>
              build_statments(statments, vars, 1 + index)

          "return" ->
            build_return(statment["statment"], vars) <>
              build_statments(statments, vars, 1 + index)

          _ ->
            nil
        end
    end
  end

  def build_do(doStatment, vars) do
    subroutineCall = doStatment["subroutineCall"]

    build_subroutineCall(subroutineCall, vars)
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

  def build_expression(expression, vars, index \\ 0, ops \\ []) do
    chunk = Enum.at(expression, index)

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
    end
  end

  def build_subroutineCall(subroutineCall, vars) do
    build_expressionList(subroutineCall["expressionList"], vars) <>
      "call " <>
      subroutineCall["completeName"] <>
      " " <> Integer.to_string(Enum.count(subroutineCall["expressionList"])) <> "\n"
  end

  def build_expression_op(op) do
    case op["operator"] do
      "+" -> "add\n"
      "*" -> "call Math.multiply 2\n"
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

  def build_let(letStatment, vars) do
    varName = letStatment["varName"]
    expression = letStatment["expression"]

    build_expression(expression, vars) <>
      "pop " <> get_var_scope_index(varName, vars, :local) <> "\n"
  end

  def build_return(returnStatment, vars) do
    expression = returnStatment["expression"]

    case expression do
      nil ->
        "return\n"

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
                get_var_scope_index(varName, vars, :local, 1 + listIndex, 0, 1 + overallIndex)

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
        item = Enum.at(vars["fields"], listIndex)

        case item do
          nil -> get_var_scope_index(varName, vars, :static)
          _ -> get_var_scope_index(varName, vars, :field, 1 + listIndex)
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
                get_var_scope_index(varName, vars, :static, 1 + listIndex, 0, 1 + overallIndex)

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
