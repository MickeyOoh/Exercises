defmodule Binary do
  def to_decimal(string) do
    if !String.match?(string, ~r{[^10]}) do
      string 
      |> bits 
      |> Enum.reverse() 
      |> Enum.with_index() 
      |> sum
    else
      0
    end
  end

  defp bits(string) do
    Enum.map(Regex.scan(~r{[10]}, string), &(&1 == ["1"]))
  end
  defp sum(bits)  do
    #IO.inspect bits
    Enum.reduce(bits, 0, 
            fn bit, acc -> acc + power_of_two(bit) end
      )
  end
  defp power_of_two({false, _}), do: 0
  defp power_of_two({true, exponent}) do
    :math.pow(2, exponent)
  end
end
