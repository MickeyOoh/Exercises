defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min
  factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    factors = Enum.into(min_factor..max_factor, [])
    set_x(factors, factors, %{})
  end
  def set_x([], _factors, map), do: map
  def set_x([x | t], [y | t], map) do 
    map = set_xy(x, [y | t], map)
    set_x(t, t, map) 
  end
  def set_xy(_x, [], map), do: map
  def set_xy(x, [y | t], map) do 
    map = if palindrome?(x * y) do 
      add_factor(map, x, y)
    else
      map
    end 
    set_xy(x, t, map)
  end 
  defp palindrome?(number) do 
    String.reverse(to_string(number)) == to_string(number)
  end
  defp add_factor(map, x, y) do
    Map.update(map, x * y, [[x,y]],
               fn val -> Enum.concat(val, [[x,y]]) 
               end)
  end 
end
