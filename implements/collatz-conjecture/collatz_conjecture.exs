defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(number :: pos_integer) :: pos_integer
  def calc(number) when number > 0 and is_integer(number) do 
    calc(number, 0)
  end
  def calc(1, steps), do: steps

  def calc(number, steps) when rem(number, 2) == 0 do
    calc(div(number, 2), steps + 1)
  end
  def calc(number, steps) do
    calc(number * 3 + 1, steps + 1)
  end
  #def calc(input) do
  ##  cond do
  #    rem(input, 2) == 0 ->
  #       div(input, 2)
  #    true ->
  #       input * 3 + 1
  #  end
  #end
end
