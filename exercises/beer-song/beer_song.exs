defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) when number <= 0 do 
    "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
  end
  def verse(1) do 
    "1 bottle of beer on the wall, #{plstr(1)} of beer.\nTake it down and pass it around, #{plstr(0)} of beer on the wall.\n"
  end
  def verse(number) do
    # Your implementation here...
    "#{plstr(number)} of beer on the wall, #{plstr(number)} of beer.\nTake one down and pass it around, #{plstr(number - 1)} of beer on the wall.\n"
  end
  def plstr(number) do 
    case number do 
      0 -> "no more bottles"
      1 -> "1 bottle"
      _ -> "#{number} bottles"
    end
  end
  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    # Your implementation here...
    range
    |> Enum.map(&verse/1)
    |> Enum.join("\n") 
  end
end
