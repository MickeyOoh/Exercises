defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    #if Regex.scan(~r/[A-z2-9\W]/, string) == [] do
    if Regex.scan(~r/[^10]/, string) == [] do
      #String.to_integer(string, 2) 
      Regex.scan(~r/[10]/, string) 
      |> List.flatten()
      |> Enum.map( &(String.to_integer(&1)))
      |> to_convert(0)
    else
      0
    end
    #lst = String.to_charlist(string)
    #to_convert(lst, 0)
  end
  def to_convert([], sum) do 
    #IO.puts "final - #{sum}"
    sum
  end
  def to_convert([head | tail], sum) do 
    sum = 2 * sum + head
    #IO.puts "2 * #{sum} + #{head}"
    to_convert(tail, sum) 
  end
end
