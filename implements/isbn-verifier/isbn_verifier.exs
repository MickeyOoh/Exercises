defmodule ISBNVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @regex ~r/^(\d-?){9}(\d|X)$/
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    if Regex.match?(@regex, isbn) do 
      checksum =
        isbn
        |> String.replace("-", "")
        |> String.graphemes()
        #|> IO.inspect
        |> Enum.zip(10..1)
        #|> IO.inspect
        |> Enum.map(&checksum_weighting/1)
        #|> IO.inspect
        |> Enum.sum()
      rem(checksum, 11) == 0
    else
      false
    end
  end
  def checksum_weighting({"X", 1}), do: 10
  def checksum_weighting({digit, weight}) do 
    String.to_integer(digit) * weight
  end

end
