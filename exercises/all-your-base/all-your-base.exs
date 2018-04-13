defmodule AllYourBase do
  #import Integer
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(digits, base_a, base_b) do
  	cond do
  	  base_a > 1 and base_b > 1 and digits != [] ->
        num = digtodec(digits, base_a, 0)
        case num do
          nil -> nil
          0   -> [0]
          num -> 
           conv_notation(num, base_b, [])
        end 
      true -> #IO.puts "Illegal number or list"
        nil
    end
    
  end
  def conv_notation(0, _base_b, list) do 
    list
  end
  def conv_notation(sum, base_b, list) do 
    #num = mod(sum, base_b)
    num = rem(sum, base_b)
    #sum = trunc(sum/base_b)
    sum = div(sum, base_b)
    list = [num] ++ list
    conv_notation(sum, base_b, list)
  end
  def digtodec([], _base_a, sum) do
    sum
  end
  def digtodec([head | tail], base_a, sum) do
    cond do 
      head < base_a and head >= 0->
        sum = sum * base_a + head
        digtodec(tail, base_a, sum)
      true ->
        nil
    end
  end
end
