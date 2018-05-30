defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    nums = String.replace(number, " ", "")

    case Integer.parse(nums) do
      {_, ""} ->
         nums = String.codepoints(nums)
             |> Enum.map( &(String.to_integer(&1)))
         cal_sumcheck(nums, length(nums))
      _ ->
        false
    end
  end
  defp cal_sumcheck(nums, len) 
  when len >= 2 do
    order = Enum.into(0..(len - 1), [])
            |> Enum.map( fn x -> if rem(x, 2) == 0, do: 1, else: 2 end) 
            |> Enum.reverse
    res = 
       Enum.zip( order, nums)
       |> Enum.map( fn {x,y} -> x * y end)
       |> Enum.map( fn x -> if x > 9, do: 1 + rem(x, 10), else: x end)
       |> Enum.sum()
    rem(res, 10) == 0 
  end 
  defp cal_sumcheck(_, _), do: false
  def test do
    res = valid?("055 444 286")
    IO.puts "#{inspect res}"
  end
end
