defmodule Scrabble do
  @scores [{"aeioulnrst", 1},
          {"dg",2},
          {"bcmp",3},
          {"fhvwy",4},
          {"k",5},
          {"jx", 8},
          {"qz", 10}
         ]
  @regex ~r/\p{L}+/
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    letters = 
      Regex.scan(@regex, word)
      |> Enum.join()
      |> String.downcase()
      |> String.codepoints()
      #get_score(letters, 0)
      calculate(letters)
  end
  def get_score([], scores), do: scores
  def get_score([h | t], scores) do
    #IO.puts "#{h}->#{scores}" 
    {_, v} = Enum.find(@scores,{nil, 0}, 
              fn {letters, _v} -> String.contains?(letters, h) end) 
    scores = scores + v
    get_score(t, scores)
  end
  def calculate(letters) do 
    Enum.map(letters, fn letter -> get_mark(letter) end) 
    |> IO.inspect 
    |> Enum.sum()

  end
  def get_mark(letter) do
    {_, value} = Enum.find(@scores,{nil, 0}, fn {letters, _v} -> String.contains?(letters, letter) end)
    value
  end
  def rddt(), do: @scores

end
