defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @regs %{
    except_vowel: ~r/[~aeiou]/,
    xy_start:     ~r/^[xy][bcdfghijklmnpqrstvwxy]+/,
    consonant:    ~r/^(s?qu|(?:[^aeiou]*))?([aeiou].*)$/,
  }
  @suffix "ay"

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end
  def translate_word(word) do 
    word
    |> consonant_prefix_and_rest()
    |> case do 
        ["", _] -> word <> @suffix
        [consonant_prefix, rest] -> rest <> consonant_prefix <> @suffix
      _       -> word
       end
    #Regex.run
    #|> 
    #string = Regex.split(~r/[aeiou]/, phrase,
    #                     [include_captures: true,parts: 2])
    #Enum.at(string, 1) <> Enum.at(string, 2) <> Enum.at(string, 0) <> "ay" 
  end
  def consonant_prefix_and_rest(word) do 
    if Regex.match?(@regs[:xy_start], word) do 
      ["", word]
    else
      Regex.run(@regs[:consonant], word, capture: :all_but_first)
    end
  end 
  def rd_regs do 
    @regs 
  end
end
