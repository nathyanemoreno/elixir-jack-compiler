defmodule TokenType do
  # @illegal		"ILLEGAL"
  # @eof        "EOF"

  # TOKEN TYPE
  # @ident      "IDENTIFIER"
  # @intconst   "INTCONST"
  # @string     "STRINGCONST"

  # OPERATORS
  # @assign     "="
  # @plus       "+"
  # @minus      "-"
  # @asterisk   "*"
  # @slash      "/"
  # @op_and     "&"
  # @op_or      "|"
  # @not        "~"
  # @dot        "."
  # @lt         "<"
  # @gt         ">"
  # @eq         "="

  # DELIMITERS
  # @comma      ","
  # @semicolon  ";"
  # @lparen     "("
  # @rparen     ")"
  # @lbrace     "{"
  # @rbrace     "}"
  # @lbracket   "["
  # @rbracket   "]"

  # KEYWORDS
  # @method     "METHOD"
  # @static     "STATIC"
  # @int        "INT"
  # @boolean    "BOOLEAN"
  # @kw_true    "TRUE"
  # @null       "NULL"
  # @let        "LET"
  # @if         "IF"
  # @while      "WHILE"
  # @construct  "CONSTRUCTOR"
  # @field      "FIELD"
  # @var        "VAR"
  # @char       "CHAR"
  # @void       "VOID"
  # @class      "CLASS"
  # @kw_false   "FALSE"
  # @do_do      "DO"
  # @cond_else  "ELSE"
  # @return     "RETURN"
  # @function   "FUNCTION"
  # @this       "THIS"

  # defstruct token: %{ :keywords => [ @this ] }
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

  # def symbols do
  #   %{
  #       :comma      => ",",
  #       :semicolon  => ";",
  #       :lparen     => "(",
  #       :rparen     => ")",
  #       :lbrace     => "{",
  #       :rbrace     => "}",
  #       :lbracket   => "[",
  #       :rbracket   => "]",
  #       :assign     =>  "=",
  #       :plus       =>  "+",
  #       :minus      =>  "-",
  #       :asterisk   =>  "*",
  #       :slash      =>  "/",
  #       :op_and     =>  "&",
  #       :op_or      =>  "|",
  #       :not        =>  "~",
  #       :dot        =>  ".",
  #       :lt         =>  "<",
  #       :gt         =>  ">",
  #       :eq         =>  "=",
  #   }
  # end

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
  # object = fileName |> DFAToken.peekToken(0, cCharIndex, "")
  # token = object["token"]
  fileName |> DFA.peekToken(0, cCharIndex, "")

  # IO.inspect([token, type])
  # [object["index"], token, type]
end

  def tokenType(tk) do
    cond do
      TokenType.keywords()[tk] -> :keyword
      TokenType.symbols()[tk] -> :symbol
      TokenType.tokens()[tk] -> :token
      !TokenType.keywords()[tk] -> :identifier
      0 -> nil
    end
  end

  def tokenTypeWithValue(tk) do
    cond do
      TokenType.keywords()[tk] -> %{"type" => :keyword, "token" => tk}
      TokenType.symbols()[tk] -> %{"type" => :symbol, "token" => tk}
      TokenType.tokens()[tk] -> %{"type" => :token, "token" => tk}
      !TokenType.keywords()[tk] -> %{:type => :ident, :token => tk}
      true -> nil
    end
  end

  def parseToken([eof | info]) do
    [tk | cCharIndex] = info
    [eof, cCharIndex, tk]
  end


end
