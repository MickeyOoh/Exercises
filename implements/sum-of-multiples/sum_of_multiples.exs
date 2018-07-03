defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    if limit < Enum.min(factors) do
      0
    else 
      Enum.filter(1..(limit - 1),
            fn num -> Enum.any?(factors, &rem(num,&1) == 0) end)
      #|> IO.inspect
      |> Enum.sum()
    end
  end
  def test do 
    to(10,[3,5])
  end
end
