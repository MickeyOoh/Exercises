defmodule TwelveDays do
  @days [
    {"a",     "first",   "Partridge in a Pear Tree"},
    {"two",   "second",  "Turtle Doves"},
    {"three", "third",   "French Hens"},
    {"four",  "fourth",  "Calling Birds"},
    {"five",  "fifth",   "Gold Rings"},
    {"six",   "sixth",   "Geese-a-Laying"},
    {"seven", "seventh", "Swans-a-Swimming"},
    {"eight", "eighth",  "Maids-a-Milking"},
    {"nine",  "ninth",   "Ladies Dancing"},
    {"ten",   "tenth",   "Lords-a-Leaping"},
    {"eleven","eleventh","Pipers Piping"},
    {"twelve","twelfth", "Drummers Drumming"}
  ] 
  
  for {{count, ordinal, gift},number} <- Enum.with_index(@days, 1) do 
    def count(unquote(number)), do: unquote(count)
    def ordinal(unquote(number)), do: unquote(ordinal)
    def gift(unquote(number)) do
      "#{count(unquote(number))} #{unquote(gift)}"
    end 
  end
  
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()

  def verse(number) do
    "#{beginning(number)}#{gift_marks(number,"")}" 
  end
  def beginning(number) do 
    "On the #{ordinal(number)} day of Christmas my true love gave to me, "
  end

  def gift_marks(1, sentences) do
    if String.length(sentences) > 0 do
      sentences <> "and " <> gift(1) <> "." 
    else
      gift(1) <> "." 
    end  
  end
  def gift_marks(number, sentences) do 
    sentences = sentences <> gift(number) <> ", " 
    gift_marks(number - 1, sentences)    
  end
  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer,
               ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Range.new(starting_verse, ending_verse)
    |> Enum.map(  &verse/1)
    |> Enum.join( "\n") 
  end
  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    Enum.map(1..12, &verse/1 )
    |> Enum.join( "\n")
  end
end
