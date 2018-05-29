defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) do
    unless Enum.member?(Range.new(0,String.length(number_string)), size) do
      raise ArgumentError
    end 
    if size > 0 do 
      nums = String.codepoints(number_string)
             |> Enum.map( fn x -> String.to_integer(x) end)
      calculate(nums, 0, size - 1, {0, []})
    else 
      1
    end

  end
  def calculate(nums, _s, e, {max, _lst}) 
  when e >= length(nums) do
    #{max, lst}
    max
  end 
  def calculate(nums, s, e, {max, lst}) do 
    dtlist = Enum.slice(nums, s..e) 
    #IO.inspect dtlist
    result = Enum.reduce(dtlist, 1, fn num, acc -> num * acc end)
    s = s + 1
    e = e + 1
    if result < max do
      calculate(nums, s, e, {max, lst})
    else
      calculate(nums, s, e, {result, dtlist})
    end
  end
end
