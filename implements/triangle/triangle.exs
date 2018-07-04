defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind2(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind2(a, b, c) when a <= 0 or b <= 0 or c <= 0 do
    {:error, "all side lengths must be positive"}
  end
  def kind2(a, b, c) when a + b <= c or b + c <= a or c + a <= b do
    {:error, "side lengths violate triangle inequality"}
  end
  def kind2(a, b, c) do
    cond do
      a == b and b == c -> {:ok, :equilateral}
      a == b or b == c or c == a -> {:ok, :isosceles} 
      true -> {:ok, :scalene}
    end
  end

  def kind(a,b,c) do 
    Enum.sort([a,b,c])
    |> check()
  end 
  def check([a,_,_]) when a <= 0 do
    {:error, "all side lengths must be positive"}
  end
  def check([a,b,c]) when a + b <= c do
    {:error, "side lengths violate triangle inequality"}
  end
  def check([x,x,x]), do: {:ok, :equilateral}
  def check([x,x,_]), do: {:ok, :isosceles}
  def check([_,x,x]), do: {:ok, :isosceles}
  def check([_,_,_]), do: {:ok, :scalene}
end
