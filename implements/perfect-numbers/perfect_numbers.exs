defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0 do
    {:error, "Classification is only possible for natural numbers."}
  end
  def classify(number) do
    list = factors(number)
    sum = Enum.sum(list)
    cond do 
      sum == number -> {:ok, :perfect}
      sum > number  -> {:ok, :abundant}
      true          -> {:ok, :deficient}
    end
  end
  def factors(1), do: []
  def factors(number) do
    limit = div(number, 2)
    factors(2,limit, number, {[1], []})
  end
  def factors(aliquot,limit, number, aliquots  = {forward, backward})
  when aliquot < limit  do 
    if rem(number, aliquot) == 0  do 
      limit = div(number, aliquot)
      backward = [limit | backward] 
      forward  = [aliquot | forward]
      factors(aliquot + 1,limit, number, {forward, backward})
    else 
      factors(aliquot + 1,limit, number, aliquots)
    end
  end
  def factors(_,_,_, {forward, backward}) do
    Enum.reverse(forward) ++ backward
  end
end
