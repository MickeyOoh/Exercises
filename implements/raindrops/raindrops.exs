defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    sound(number,["","",""])   
  end
  def sound(number, [_,str5,str7]) when rem(number, 3) == 0 do 
    sound(div(number, 3), ["Pling",str5,str7] )
  end
  def sound(number, [str3,_,str7]) when rem(number, 5) == 0 do 
    sound(div(number, 5), [str3,"Plang",str7] )
  end
  def sound(number, [str3,str5,_]) when rem(number, 7) == 0 do 
    sound(div(number, 7), [str3,str5,"Plong"] )
  end
  def sound(number, result) when result == ["","",""], do: to_string(number) 
  def sound(_number, result), do: Enum.join(result) 
    
end
