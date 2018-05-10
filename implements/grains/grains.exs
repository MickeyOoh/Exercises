defmodule Grains do
  use Bitwise, only_operators: true
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) 
  when number in 1..64 do
    {:ok, 1 <<< (number - 1)} 
  end
  def square(_) do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end
  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    {:ok, 
      Enum.reduce(1..64, 0,
                  fn n, acc -> 
                     {:ok, sq} = square(n)
                     acc + sq
                  end)
    }  
  end
end
