defmodule Minesweeper do
  @adjacent_vecs for x <- [-1, 0, 1],
                     y <- [-1, 0, 1],
                     x != 0 or y != 0, do: {x, y} 
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate([]), do: []
  def annotate(board) do
    h = length(board)    # hight 
    w = String.length(hd(board)) #width
    layout = List.duplicate(List.duplicate(0, w), h)
    
    result =
      Enum.map(board, fn(x) -> String.to_charlist(x) end)  
      |> find_pos( {0,0},[]) 
      #|> IO.inspect
      |> countup( layout, {w, h})
    #IO.puts "result->\n#{inspect result}"
    Enum.map(result, fn x -> 
         Enum.map( x, fn char ->
             case char do
               ?* -> ?*
               0  -> ?\s
               _  -> char + ?0
             end
         end)
         |> to_string
      end) 
    #board = Enum.map(board, fn(x) -> String.to_charlist(x) end)  
    #asterisks = find_pos(board, {0,0},[]) 
    #IO.inspect asterisks
    #result = countup(asterisks, layout, {w, h})
    #result = setpos(asterisks, result) 
  end
  # add_adjacents(d=acc, c={x, y}, bound0 {w, h})
  #defp add_adjacents(d, c, bounds) do 
  #  Enum.reduce(@adjacent_vecs, d,
  #       fn v, acc -> 
  #            c1 = add_vec(c, v)
  #            if valid?(c1, bounds) do 
  #              Map.update(acc, c1, 1, &(&1 + 1))
  #            else
  ##              acc
  #            end
  #       end)
  #end
  def countup([], layout, _), do: layout
  def countup( [c | t], layout, bounds) do
    #IO.puts "c-> #{inspect c},layout = #{inspect layout}"
    layout = update(layout, c, ?*)
    #IO.inspect layout
    layout = 
      Enum.reduce(@adjacent_vecs, layout,
         fn v, acc -> 
           c1 = add_vec(c, v)
           if valid?(c1, bounds) do
             dat = read(acc, c1)
             if dat != ?*, do: update(acc, c1, dat + 1), else: acc 
             #update(acc, c1, dat + 1) 
           else
             acc
           end
         end) 
    countup(t, layout, bounds)
  end
  def update(layout, {x, y}, dat) do
    List.update_at(layout, y, &(update_x(&1, x, dat))) 
  end
  def update_x(yline, x, dat) do
    List.update_at(yline, x, fn _d -> dat end)
  end
  def read(layout, {x, y}), do: Enum.at(Enum.at(layout, y), x)

  defp add_vec({cx, cy}, {vx, vy}), 
     do: {cx + vx, cy + vy}
  defp valid?({cx, cy}, {w, h}), 
  do: cx >= 0 and cx < w and cy >= 0 and cy < h

  def find_xcols([],        {_x,_y}, acc), do: acc
  def find_xcols([xh | xt], {x,y}, acc) do
    acc = if xh  == ?* do
      acc ++ [{x,y}]   
    else
      acc
    end
    #IO.puts "{#{x},#{y}}->#{xh} acc->#{inspect acc}" 
    find_xcols(xt, {x + 1, y}, acc)  
  end
  def find_pos([],        {_x,_y}, acc), do: acc
  def find_pos([yh | yt], {x,y}, acc) do 
    acc = find_xcols( yh,  {0,y}, acc) 
    find_pos(yt, {x, y + 1}, acc)
  end
  
  @testpat [[" * * "],[" ", "*", " ", "*", " "],
            ["  *  ", "  *  ", "*****","  *  ", "  *  "] ] 
  def test(pat) do 
    Enum.at(@testpat, pat)
  end
end
