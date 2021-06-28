defmodule DFAToken do
  def peekToken(f, cState, cCharIndex, carry) do
    case cCharIndex >= String.length(f) do
      true ->
        %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

      _ ->
        char = String.at(f, cCharIndex)
        <<utf8Char::utf8>> = char
        nCharIndex = cCharIndex + 1
        # IO.inspect(Integer.to_string(cState) <?  -> " <> carry)
        # IO.inspect( %{ "token" => carry, "index" => cCharIndex, "carry" => carry})

        case cState do
          0 ->
            case utf8Char do
              ?! ->
                peekToken(f, 1000, nCharIndex, carry <> char)

              ?/ ->
                peekToken(f, 1002, nCharIndex, "")

              ?{ ->
                peekToken(f, 1007, nCharIndex, carry <> char)

              ?} ->
                peekToken(f, 1008, nCharIndex, carry <> char)

              ?( ->
                peekToken(f, 1009, nCharIndex, carry <> char)

              ?) ->
                peekToken(f, 1010, nCharIndex, carry <> char)

              ?[ ->
                peekToken(f, 1011, nCharIndex, carry <> char)

              ?] ->
                peekToken(f, 1012, nCharIndex, carry <> char)

              ?. ->
                peekToken(f, 1013, nCharIndex, carry <> char)

              ?, ->
                peekToken(f, 1014, nCharIndex, carry <> char)

              ?; ->
                peekToken(f, 1015, nCharIndex, carry <> char)

              ?+ ->
                peekToken(f, 1016, nCharIndex, carry <> char)

              ?- ->
                peekToken(f, 1017, nCharIndex, carry <> char)

              ?* ->
                peekToken(f, 1018, nCharIndex, carry <> char)

              ?& ->
                peekToken(f, 1019, nCharIndex, carry <> char)

              ?| ->
                peekToken(f, 1020, nCharIndex, carry <> char)

              ?< ->
                peekToken(f, 1021, nCharIndex, carry <> char)

              ?> ->
                peekToken(f, 1022, nCharIndex, carry <> char)

              ?= ->
                peekToken(f, 1023, nCharIndex, carry <> char)

              ?~ ->
                peekToken(f, 1024, nCharIndex, carry <> char)

              ?\n ->
                peekToken(f, 0, nCharIndex, "")

              ?\t ->
                peekToken(f, 0, nCharIndex, "")

              ?\s ->
                peekToken(f, 0, nCharIndex, "")

              _ ->
                cond do
                  char > 47 and char < 58 ->
                    peekToken(f, 2000, nCharIndex, carry <> char)

                  Char.isValid(char) ->
                    peekToken(f, 1, nCharIndex, carry <> char)

                  true ->
                    %{ "token" => carry, "index" => cCharIndex, "carry" => carry}
                end
            end

          1 ->
            cond do
              Char.isValid(char) -> peekToken(f, 1, nCharIndex, carry <> char)
              true -> %{ "token" => carry, "index" => cCharIndex, "carry" => carry}
            end

          1000 ->
            case utf8Char do
              ?= -> peekToken(f, 1001, nCharIndex, carry <> char)
              _ -> %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

            end

          1001 ->
            peekToken(f, 0, nCharIndex, carry <> char)

          1002 ->
            case utf8Char do
              ?/ -> peekToken(f, 1003, nCharIndex, "")
              ?* -> peekToken(f, 1004, nCharIndex, carry <> char)
              _ -> %{ "token" => carry, "index" => cCharIndex, "carry" => carry}
            end

          1003 ->
            case utf8Char do
              ?\n -> peekToken(f, 0, nCharIndex, carry)
              _ -> peekToken(f, 1003, nCharIndex, "")
            end

          1004 ->
            case utf8Char do
              ?* -> peekToken(f, 1005, nCharIndex, carry)
              _ -> peekToken(f, 1004, nCharIndex, carry)
            end

          1005 ->
            case utf8Char do
              ?/ -> peekToken(f, 0, nCharIndex, carry)
              ?* -> peekToken(f, 1005, nCharIndex, carry)
              _ ->peekToken(f, 1004, nCharIndex, carry)
            end

          1007 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1008 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1009 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1010 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1011 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1012 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1013 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1014 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1015 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1016 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1017 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1018 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1019 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1020 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          1021 ->
            %{ "token" => carry, "index" => cCharIndex, "carry" => carry}

          2000 ->
            case utf8Char do
              ?. -> peekToken(f, 2001, nCharIndex, carry <> char)
              true -> peekToken(f, 2000, nCharIndex, carry <> char)
            end

          2001 ->
            cond do
              Char.isNumber(char) -> peekToken(f, 2001, nCharIndex, carry <> char)
              true -> %{ "token" => carry, "index" => cCharIndex, "carry" => carry}
            end
        end
    end
  end
end
