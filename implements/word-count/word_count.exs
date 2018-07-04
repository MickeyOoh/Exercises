defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  #@regex ~r/\p{L}+/
  @ascii_punctuation ~r/!|"|\#|\$|%|&|'|\(|\)|\*|\+|,|\.|\/|:|;|<|=|>|\?|@|\    [|\\|]|\^|_|`|\{|\||}|~/ 
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    #|> do_regex(  @regex) 
    |> do_regex(  @ascii_punctuation) 
    |> List.flatten
    |> Enum.reduce( %{}, fn x, acc ->
      Map.update(acc, x, 1, fn cnt -> cnt + 1 end) end) 
  end
  def do_regex(letters, reg) do 
    #String.replace(letters, reg, " ")
    Regex.replace(reg, letters, " ") 
    #Regex.scan(reg, letters)
    |> String.split(" ", trim: true)
  end
end
