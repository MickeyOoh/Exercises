defmodule Say do
  @small_numbers ~w(
    one two three four five six seven eight nine ten
    eleven twelve thirteen fourteen fiftenn sixteen
    seventeen eighteen nineteen 
  )
  @decades ~w(
    twenty thirty forty fifty sixty seventy eighty ninety
  )
  @separators ~w(thousand million billion)

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number)
   when number < 0 or 1_000_000_000_000 <= number do
    {:error, "number is out of range"} 
  end
  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    result = 
      Integer.digits(number)
      |> padded_chunk(3, 0)
      |> translate_chunks()
      |> clean_join(" ")
    {:ok, result}
  end
  
  @spec translate_chunks(list) :: [String.t()]
  def translate_chunks(chunks) do 
    translate_chunks(chunks, Enum.count(chunks))
  end
  
  @spec translate_chunks(list, number) :: [String.t()]
  def translate_chunks([chunk], 1), do: [translate_chunk(chunk)]

  def translate_chunks([[0,0,0] | remaining], n) do
    translate_chunks(remaining, n - 1)
  end 
  def translate_chunks([chunk | remaining], n) do 
    chunk_in_english =
      [
        translate_chunk(chunk), 
        Enum.at(@separators, n - 2)
      ]
      |> clean_join(" ") 

    [chunk_in_english | translate_chunks(remaining, n - 1)]
  end

  @spec translate_chunk([number]) :: String.t()
  def translate_chunk([0,0,0]), do: ""
  def translate_chunk([0,0,ones]), do: ones_in_english(ones)
  def translate_chunk([0,1,ones]), do: ones_in_english(ones + 10)
  def translate_chunk([0,tens,0]), do: tens_in_english(tens)
  def translate_chunk([0,tens,ones]) do
    [
      tens_in_english(tens),
      ones_in_english(ones)
    ]
    |> clean_join("-")
  end
  def translate_chunk([hundreds,0,0]) do 
    "#{ones_in_english(hundreds)} hundred"
  end
  def translate_chunk([hundreds, tens, ones]) do 
    [
      translate_chunk([hundreds, 0, 0]),
      translate_chunk([  0, tens, ones])
    ]
    |> clean_join(" ")
  end

  @spec ones_in_english(number) :: String.t()
  def ones_in_english(index), do: Enum.at(@small_numbers, index - 1)

  @spec tens_in_english(number) :: String.t()
  def tens_in_english(index), do: Enum.at(@decades, index - 2)

  @spec clean_join([any], String.t()) :: String.t()
  defp clean_join(collection, separator) do 
    collection
    |> reject_blank
    |> Enum.join(separator)
  end
  @spec reject_blank([any]) :: [any]
  defp reject_blank(col) do 
    col
    |> Enum.reject(&(&1 == nil || &1 == ""))
  end

  @doc """
    xxx,xxx,xxx,xxx   chunk_size 3, 
  """
  @spec padded_chunk([any], number, any) :: [any]
  def padded_chunk(list, chunk_size, pad) do 
    len = Enum.count(list)
    rem = rem(len, chunk_size)
    pad_size = pad_size(chunk_size, rem)
    #pad_size = pad_size(chunk_size, rem(Enum.count(list), chunk_size))
    pad(list, pad, pad_size)
    |> Enum.chunk(chunk_size)
  end  

  @spec pad_size(number, number) :: number 
  def pad_size(_, 0), do: 0
  def pad_size(total, rem), do: total - rem 
  
  @spec pad([any], any, number) :: [any]
  def pad(list, _, 0), do: list 
  def pad(list, pad, count) do 
    [pad] ++ pad(list, pad, count - 1)
  end 

end
