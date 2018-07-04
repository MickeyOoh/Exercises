defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    rows = String.split(input, "\n")
    rows
    |> padding( )
    |> Enum.map( &String.codepoints/1)
    |> transpose_zip()
    |> Enum.map(  &Enum.join/1) 
    |> Enum.join( "\n")
    |> String.trim_trailing() 
  end
  def transpose_zip(matrix) do 
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
  def get_longest_rows(rows) do 
    Enum.map(rows, &String.length/1)
    |> Enum.max()
  end
  def padding(rows) do 
    len = get_longest_rows(rows)
    Enum.map(rows, &(String.pad_trailing(&1,len)))
  end
end
