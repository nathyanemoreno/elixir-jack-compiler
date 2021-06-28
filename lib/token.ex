defmodule TokenType do
  def keywords do
    %{
      "method" => :method,
      "static" => :static,
      "constructor" => :construct,
      "field" => :field,
      "do" => :kw_do,
      "class" => :class,
      "function" => :function,
      "return" => :return,
      "let" => :let,
      "var" => :var,
      "void" => :void,
      "while" => :while,
      "this" => :this,
      "if" => :if,
      "else" => :else,
      "char" => :char,
      "int" => :int,
      "boolean" => :boolean,
      "null" => :null,
      "false" => :kw_false,
      "true" => :kw_true
    }
  end
  def symbols do
    %{
      "," => :comma,
      ";" => :semicolon,
      "(" => :lparen,
      ")" => :rparen,
      "{" => :lbrace,
      "}" => :rbrace,
      "[" => :lbracket,
      "]" => :rbracket,
      "=" => :assign,
      "+" => :plus,
      "-" => :minus,
      "*" => :asterisk,
      "/" => :slash,
      "&" => :op_and,
      "|" => :op_or,
      "~" => :not,
      "." => :dot,
      "<" => :lt,
      ">" => :gt
      # "=" =>  :eq,
    }
  end
  def operators do
    %{
      "=" => :assign,
      "+" => :plus,
      "-" => :minus,
      "*" => :asterisk,
      "/" => :slash,
      "&" => :op_and,
      "|" => :op_or,
      "~" => :not,
      "." => :dot,
      "<" => :lt,
      ">" => :gt
      # "=" => :eq,
    }
  end

  def tokens do
    %{
      :ident => "IDENTIFIER",
      :intconst => "INTCONST",
      :string => "STRINGCONST",
      :illegal => "ILLEGAL",
      :eof => "EOF"
    }
  end
end

defmodule Token do
  def getToken(fileName, cCharIndex) do
    fileName |> DFA.peekToken(0, cCharIndex, "")
  end

  def tokenType(token) do
    getToken(token, 0) |> Map.get("type")
  end
end
