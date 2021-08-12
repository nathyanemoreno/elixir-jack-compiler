defmodule LexerDFA do
  def checkTokenToken(f, cState, cCharIndex, carry) do
    char = if cCharIndex < String.length(f), do: String.at(f, cCharIndex), else: "\0"

    <<utf8Char::utf8>> = char
    nCharIndex = cCharIndex + 1

    # Integer.to_string(cCharIndex) <> " - " <> carry)

    case cState do
      0 ->
        case utf8Char do
          ?c ->
            checkTokenToken(f, 4, nCharIndex, carry <> char)

          ?h ->
            checkTokenToken(f, 1, nCharIndex, carry <> char)

          ?o ->
            checkTokenToken(f, 9, nCharIndex, carry <> char)

          ?f ->
            checkTokenToken(f, 26, nCharIndex, carry <> char)

          ?m ->
            checkTokenToken(f, 35, nCharIndex, carry <> char)

          ?s ->
            checkTokenToken(f, 41, nCharIndex, carry <> char)

          ?v ->
            checkTokenToken(f, 49, nCharIndex, carry <> char)

          ?t ->
            checkTokenToken(f, 56, nCharIndex, carry <> char)

          ?i ->
            checkTokenToken(f, 61, nCharIndex, carry <> char)

          ?w ->
            checkTokenToken(f, 64, nCharIndex, carry <> char)

          ?b ->
            checkTokenToken(f, 69, nCharIndex, carry <> char)

          ?n ->
            checkTokenToken(f, 76, nCharIndex, carry <> char)

          ?l ->
            checkTokenToken(f, 80, nCharIndex, carry <> char)

          ?d ->
            checkTokenToken(f, 83, nCharIndex, carry <> char)

          ?e ->
            checkTokenToken(f, 85, nCharIndex, carry <> char)

          ?r ->
            checkTokenToken(f, 89, nCharIndex, carry <> char)

          ?! ->
            checkTokenToken(f, 1000, nCharIndex, carry <> char)

          ?/ ->
            checkTokenToken(f, 1002, nCharIndex, carry <> char)

          ?{ ->
            checkTokenToken(f, 1007, nCharIndex, carry <> char)

          ?} ->
            checkTokenToken(f, 1008, nCharIndex, carry <> char)

          ?( ->
            checkTokenToken(f, 1009, nCharIndex, carry <> char)

          ?) ->
            checkTokenToken(f, 1010, nCharIndex, carry <> char)

          ?[ ->
            checkTokenToken(f, 1011, nCharIndex, carry <> char)

          ?] ->
            checkTokenToken(f, 1012, nCharIndex, carry <> char)

          ?. ->
            checkTokenToken(f, 1013, nCharIndex, carry <> char)

          ?, ->
            checkTokenToken(f, 1014, nCharIndex, carry <> char)

          ?; ->
            checkTokenToken(f, 1015, nCharIndex, carry <> char)

          ?+ ->
            checkTokenToken(f, 1016, nCharIndex, carry <> char)

          ?- ->
            checkTokenToken(f, 1017, nCharIndex, carry <> char)

          ?* ->
            checkTokenToken(f, 1018, nCharIndex, carry <> char)

          ?& ->
            checkTokenToken(f, 1019, nCharIndex, carry <> char)

          ?| ->
            checkTokenToken(f, 1020, nCharIndex, carry <> char)

          ?< ->
            checkTokenToken(f, 1021, nCharIndex, carry <> char)

          ?> ->
            checkTokenToken(f, 1022, nCharIndex, carry <> char)

          ?= ->
            checkTokenToken(f, 1023, nCharIndex, carry <> char)

          ?~ ->
            checkTokenToken(f, 1024, nCharIndex, carry <> char)

          ?" ->
            checkTokenToken(f, 1025, nCharIndex, "")

          ?\n ->
            checkTokenToken(f, 0, nCharIndex, "")

          ?\t ->
            checkTokenToken(f, 0, nCharIndex, "")

          ?\s ->
            checkTokenToken(f, 0, nCharIndex, "")

          0 ->
            nil

          _ ->
            cond do
              Char.isNumber(char) ->
                checkTokenToken(f, 2000, nCharIndex, carry <> char)

              Char.isValid(char) ->
                checkTokenToken(f, 3000, nCharIndex, carry <> char)

              true ->
                %{"token" => carry <> char, "type" => :undefined, "index" => nCharIndex}
            end
        end

      1 ->
        case utf8Char do
          ?a ->
            checkTokenToken(f, 2, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      2 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 3, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      3 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      4 ->
        case utf8Char do
          ?h ->
            checkTokenToken(f, 1, nCharIndex, carry <> char)

          ?l ->
            checkTokenToken(f, 5, nCharIndex, carry <> char)

          ?o ->
            checkTokenToken(f, 9, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      5 ->
        case utf8Char do
          ?a ->
            checkTokenToken(f, 6, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      6 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 7, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      7 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 8, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      8 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      9 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 10, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      10 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 11, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      11 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 12, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      12 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 13, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      13 ->
        case utf8Char do
          ?u ->
            checkTokenToken(f, 14, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      14 ->
        case utf8Char do
          ?c ->
            checkTokenToken(f, 15, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      15 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 16, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      16 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 17, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      17 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 18, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      18 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      19 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 20, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      20 ->
        case utf8Char do
          ?c ->
            checkTokenToken(f, 21, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      21 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 22, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      22 ->
        case utf8Char do
          ?i ->
            checkTokenToken(f, 23, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      23 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 24, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      24 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 25, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      25 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      26 ->
        case utf8Char do
          ?u ->
            checkTokenToken(f, 19, nCharIndex, carry <> char)

          ?a ->
            checkTokenToken(f, 27, nCharIndex, carry <> char)

          ?i ->
            checkTokenToken(f, 31, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      27 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 28, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      28 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 29, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      29 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 30, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      30 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      31 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 32, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      32 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 33, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      33 ->
        case utf8Char do
          ?d ->
            checkTokenToken(f, 34, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      34 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      35 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 36, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      36 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 37, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      37 ->
        case utf8Char do
          ?h ->
            checkTokenToken(f, 38, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      38 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 39, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      39 ->
        case utf8Char do
          ?d ->
            checkTokenToken(f, 40, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      40 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      41 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 42, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      42 ->
        case utf8Char do
          ?a ->
            checkTokenToken(f, 43, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      43 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 44, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      44 ->
        case utf8Char do
          ?i ->
            checkTokenToken(f, 45, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      45 ->
        case utf8Char do
          ?c ->
            checkTokenToken(f, 46, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      46 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      47 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 48, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      48 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      49 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 50, nCharIndex, carry <> char)

          ?a ->
            checkTokenToken(f, 47, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      50 ->
        case utf8Char do
          ?i ->
            checkTokenToken(f, 51, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      51 ->
        case utf8Char do
          ?d ->
            checkTokenToken(f, 52, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      52 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      53 ->
        case utf8Char do
          ?i ->
            checkTokenToken(f, 54, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      54 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 55, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      55 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      56 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 57, nCharIndex, carry <> char)

          ?h ->
            checkTokenToken(f, 53, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      57 ->
        case utf8Char do
          ?u ->
            checkTokenToken(f, 58, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      58 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 59, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      59 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      60 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      61 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 62, nCharIndex, carry <> char)

          ?f ->
            checkTokenToken(f, 60, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      62 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 63, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      63 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      64 ->
        case utf8Char do
          ?h ->
            checkTokenToken(f, 65, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      65 ->
        case utf8Char do
          ?i ->
            checkTokenToken(f, 66, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      66 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 67, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      67 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 68, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      68 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      69 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 70, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      70 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 71, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      71 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 72, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      72 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 73, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      73 ->
        case utf8Char do
          ?a ->
            checkTokenToken(f, 74, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      74 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 75, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      75 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      76 ->
        case utf8Char do
          ?u ->
            checkTokenToken(f, 77, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      77 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 78, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      78 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 79, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      79 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      80 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 81, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      81 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 82, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      82 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      83 ->
        case utf8Char do
          ?o ->
            checkTokenToken(f, 84, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      84 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      85 ->
        case utf8Char do
          ?l ->
            checkTokenToken(f, 86, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      86 ->
        case utf8Char do
          ?s ->
            checkTokenToken(f, 87, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      87 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 88, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      88 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      89 ->
        case utf8Char do
          ?e ->
            checkTokenToken(f, 90, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      90 ->
        case utf8Char do
          ?t ->
            checkTokenToken(f, 91, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      91 ->
        case utf8Char do
          ?u ->
            checkTokenToken(f, 92, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      92 ->
        case utf8Char do
          ?r ->
            checkTokenToken(f, 93, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      93 ->
        case utf8Char do
          ?n ->
            checkTokenToken(f, 94, nCharIndex, carry <> char)

          _ ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)
        end

      94 ->
        cond do
          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :keyword, "index" => cCharIndex}
        end

      1000 ->
        case utf8Char do
          ?= -> checkTokenToken(f, 1001, nCharIndex, carry <> char)
          _ -> %{"token" => carry, "type" => :symbol, "index" => cCharIndex}
        end

      1001 ->
        checkTokenToken(f, 0, nCharIndex, carry <> char)

      1002 ->
        case utf8Char do
          ?/ -> checkTokenToken(f, 1003, nCharIndex, "")
          ?* -> checkTokenToken(f, 1004, nCharIndex, carry <> char)
          _ -> %{"token" => carry, "type" => :symbol, "index" => cCharIndex}
        end

      1003 ->
        case utf8Char do
          ?\n -> checkTokenToken(f, 0, nCharIndex, carry)
          _ -> checkTokenToken(f, 1003, nCharIndex, "")
        end

      1004 ->
        case utf8Char do
          ?* -> checkTokenToken(f, 1005, nCharIndex, carry)
          _ -> checkTokenToken(f, 1004, nCharIndex, carry)
        end

      1005 ->
        case utf8Char do
          ?/ -> checkTokenToken(f, 0, nCharIndex, carry)
          ?* -> checkTokenToken(f, 1005, nCharIndex, carry)
          _ -> checkTokenToken(f, 1004, nCharIndex, carry)
        end

      1007 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1008 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1009 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1010 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1011 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1012 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1013 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1014 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1015 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1016 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1017 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1018 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1019 ->
        %{"token" => "&amp;", "type" => :symbol, "index" => cCharIndex}

      1020 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1021 ->
        %{"token" => "&lt;", "type" => :symbol, "index" => cCharIndex}

      1022 ->
        %{"token" => "&gt;", "type" => :symbol, "index" => cCharIndex}

      1023 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1024 ->
        %{"token" => carry, "type" => :symbol, "index" => cCharIndex}

      1025 ->
        case utf8Char do
          ?" -> checkTokenToken(f, 1026, nCharIndex, carry)
          _ -> checkTokenToken(f, 1025, nCharIndex, carry <> char)
        end

      1026 ->
        %{"token" => carry, "type" => :stringConst, "index" => cCharIndex}

      2000 ->
        cond do
          Char.isNumber(char) -> checkTokenToken(f, 2000, nCharIndex, carry <> char)
          true -> %{"token" => carry, "type" => :integerConstant, "index" => cCharIndex}
        end

      3000 ->
        cond do
          Char.isNumber(char) ->
            checkTokenToken(f, 2000, nCharIndex, carry <> char)

          Char.isValid(char) ->
            checkTokenToken(f, 3000, nCharIndex, carry <> char)

          true ->
            %{"token" => carry, "type" => :identifier, "index" => cCharIndex}
        end
    end
  end
end
