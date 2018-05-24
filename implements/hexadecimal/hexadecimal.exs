defmodule Hexadecimal do
  @base 16
  @hex_table String.split("0123456789abcdef", "", trim: true)
             |> Enum.with_index()
             |> Enum.into(%{})
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    if invalid?(hex) do 
      0
    else
      hex
      |> String.downcase()
      |> String.split("", trim: true)
      |> hextoint_recur( @base, 0)
    end
  end

  defp invalid?(hex) do 
    String.match?(hex, ~r/[^0-9a-fA-F]/)
  end
  def hextoint_recur([], _,sum), do:  sum
  def hextoint_recur([head | tail], base, sum) do 
    int = Map.get(@hex_table, head)
    sum = sum * base + int
    hextoint_recur(tail, base, sum)
  end 
end
