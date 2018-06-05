defmodule Minesweeper do
  @adjacent_vecs for x <- [-1, 0, 1],
                     y <- [-1, 0, 1],
                     x != 0 or y != 0, do: {x, y} 
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate(board) do
    h = length(board)    # hight 
    w = String.length(hd(board)) #width
    
    annotations =
      Enum.reduce(Stream.with_index(board), %{}, 
                  fn {line, y}, acc -> 
                    cols = Stream.with_index(String.to_charlist(line)) 
                    #IO.puts "cols:#{inspect cols}"
                    Enum.reduce(cols, acc, 
                       fn 
                         {?*, x}, acc ->
                           #IO.puts "{#{x}, #{y}}" 
                             add_adjacents(acc, {x, y}, {w, h}) 
                         _, acc -> acc
                       end
                    )
                  end
                 )
    IO.puts "annotations ->\n#{inspect annotations}" 
    # when "*" position is found, counter of annotation be set "*"
    # otherwise, counter number is changed as ascii by ?0 + num
    Enum.map(Stream.with_index(board), 
        fn {line, y} ->
          cols = Stream.with_index(String.to_charlist(line)) 
            Enum.map(cols, 
              fn {?*, _} -> ?*
                 {_,  x} -> 
                   case annotations[{x, y}] do
                     nil -> ?\s
                     n   -> ?0 + n
                   end
              end)
             |> to_string
       end)
    #bd = Enum.map(board, fn x -> String.codepoints(x) end)
    #find_pos(bd, []) 
    #|> IO.inspect
         
  end
  # add_adjacents(d=acc, c={x, y}, bound0 {w, h})
  defp add_adjacents(d, c, bounds) do 
    #IO.puts "d->#{inspect d},\n  c->#{inspect c}, bounds:#{inspect bounds}"
    Enum.reduce(@adjacent_vecs, d,
         fn v, acc -> 
              c1 = add_vec(c, v)
              if valid?(c1, bounds) do 
                Map.update(acc, c1, 1, &(&1 + 1))
              else
                acc
              end
         end)
  end

  defp add_vec({cx, cy}, {vx, vy}), 
     do: {cx + vx, cy + vy}
  defp valid?({cx, cy}, {w, h}), 
     do: cx >= 0 and cx < w and cy >= 0 and cy < h
  defp find_pos([], acc), do: acc
  defp find_pos([h | t], acc) do
  end 
  defp find_cols([h | t], acc) do

  end
  defp find_pos(w, h, board, acc) do
    acc = []
    acc = for y <- 0..(h-1) do
      IO.puts "acc:#{inspect acc}"

      acc = for x <- 0..(w-1) do
        acc = if chk(x, y, board) do
          acc = acc  ++ [{x,y}]
        else
          acc
        end 
      end
    end
  end
  defp chk(x, y, board) do 
    IO.puts "#{x}, #{y}"
    Enum.at(Enum.at(board, y), x) == "*"
  end
  @testpat [[" * * "],[" ", "*", " ", "*", " "],
            ["  *  ", "  *  ", "*****","  *  ", "  *  "] ] 
  def test(pat) do 
    Enum.at(@testpat, pat)
  end
  def test2 do 
    b = [" * * "]
  end
end
