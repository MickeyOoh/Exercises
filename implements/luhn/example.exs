defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  Luhn formula algorithm
  1. From the rightmost digit, which is the check digit, and moving lert,
     double the value of every second digit. The check digit is not
     doubled, the first idgit doubled is immediately to the left of the
     check digit. If the rsult of this doubling opreation is greater than
     9(e.g., 8 * 2 = 16), then add the digits of the product or
     alternatively, the same result can be found by subtracting 9 from
     the product
  2. take the sum of all the digits
  3. If the total modulo is equal to 0, then the number is valid according
     to the Luhn formula; else it is not valid.

  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number_without_spaces = String.replace(number, " ", "")

    case Integer.parse(number_without_spaces) do
      {_, ""} ->
        String.length(number_without_spaces) > 1 && checksum(number_without_spaces)

      _ ->
        false
    end
  end

  defp checksum(number) do
    0 ==
      number
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect
      |> double_even()
      |> IO.inspect
      |> Enum.sum()
      |> rem(10)
  end

  defp double_even(numlist) do
    numlist
    |> Enum.reverse()
    |> Enum.zip(Stream.cycle([1, 2]))
    |> Enum.map(fn {n, m} -> n * m end)
    |> Enum.map(fn
      n when n > 9 -> n - 9
      n -> n
    end)
  end
end
