defmodule Tournament do
  @stats_header {"Team", ["MP","W","D","L","P"]}
  @initial_stats [0,0,0,0,0]
  @doc """
  Given `input` lines representing two teams and whether the first of 
  them won, lost, or reached a draw, separated by semicolons, calculate 
  the statistics for each team's number of games played, won, drawn, 
  lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns 
  nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.map( &String.split(&1, ";"))
    |> analyze( %{})
    |> Map.to_list()
    #|> Enum.sort_by( &get_point/1, &>=/2 )
    |> Enum.sort( &compare_points/2 )
    |> List.insert_at( 0, @stats_header)
    |> Enum.map_join( "\n", &format_print/1) 
  end
  def analyze([], results), do: results
  def analyze([[a, b, p] | t], results) do 
    results =
      case p do
      "win" ->
        results |> mark_win( a) |> mark_loss(b)
        #Map.update(results, a, [1,1,0,0,3], 
        #           fn [mp,w,d,l,p] -> [mp+1, w+1,d, l, p+3] end)
        #|> Map.update(      b, [1,0,0,1,0],
        #           fn [mp,w,d,l,p] -> [mp+1, w,d, l+1, p] end)
      "draw" -> 
        results |> mark_draw( a) |> mark_draw(b)
        #Map.update(results, a, [1,0,1,0,1], 
        #           fn [mp,w,d,l,p] -> [mp+1, w,d+1, l, p+1] end)
        #|> Map.update(      b, [1,0,1,0,1],
        #           fn [mp,w,d,l,p] -> [mp+1, w,d+1, l, p+1] end)
      "loss" -> 
        results |> mark_win( b) |> mark_loss(a)
        #Map.update(results, a, [1,0,0,1,0], 
        #           fn [mp,w,d,l,p] -> [mp+1, w,d, l+1, p] end)
        #|> Map.update(      b, [1,1,0,0,3],
        #           fn [mp,w,d,l,p] -> [mp+1, w+1,d, l, p+3] end)
      _      -> results 
      end
    analyze(t, results)
  end
  def analyze([h | t], results)
  when length(h) != 3, do: analyze(t, results)

  #def get_point({_name,[_,_,_,_,points]}) do 
  #  points
  #end

  def mark_win(results, team) do 
    [mp, w, d, l, p] = Map.get(results, team, @initial_stats)
    Map.put(results, team, [mp + 1, w + 1, d, l, p + 3])
  end
  def mark_loss(results, team) do 
    [mp, w, d, l, p] = Map.get(results, team, @initial_stats)
    Map.put(results, team, [mp + 1, w,  d, l + 1 ,    p])
  end
  def mark_draw(results, team) do 
    [mp, w, d, l, p] = Map.get(results, team, @initial_stats)
    Map.put(results, team, [mp + 1, w, d + 1, l, p + 1])
  end

  def compare_points({_,score1}, {_, score2}) do 
    List.last(score1) >= List.last(score2)
  end

  def format_print({name, [mp, w, d, l, p]}) do
    [
      name |> String.pad_trailing(30),
      mp   |> to_string |> String.pad_leading(2),
      w    |> to_string |> String.pad_leading(2),
      d    |> to_string |> String.pad_leading(2),
      l    |> to_string |> String.pad_leading(2),
      p    |> to_string |> String.pad_leading(2),
    ]
    |> Enum.join(" | ")
  end

  def test do
    ["Allegoric Alaskans;Blithering Badgers;win",
     "Devastating Donkeys;Courageous Californians;draw",
     "Devastating Donkeys;Allegoric Alaskans;win",
     "Courageous Californians;Blithering Badgers;loss",
     "Blithering Badgers;Devastating Donkeys;loss",
     "Allegoric Alaskans;Courageous Californians;win"
    ]
  end
end
