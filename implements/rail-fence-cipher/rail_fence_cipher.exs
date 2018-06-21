defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode(str, rails) do
    #len = String.length(str)
    pattern = Enum.concat(Enum.to_list(          0..(rails-1)),
                        Enum.to_list((rails-2)..1          ) )
    letters = String.codepoints(str)  # str -> list
      #|> Enum.with_index()
    result = List.duplicate([], rails)
    railfence(letters, pattern, result)
    |> List.to_string()
  end
  #def set_dt([], _ , result), do: result
  def railfence([], _ , result) do
    Enum.map(result, &(Enum.reverse(&1)))
    |> List.flatten()
  end
  def railfence([hstr | tstr], [hpos | tpos], result) do 
    row = Enum.at(result, hpos)
    result = List.replace_at(result, hpos, [hstr | row])
    railfence(tstr, tpos ++ [hpos], result)
  end
  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str
  def decode(str, rails) do
    pattern = Enum.concat(Enum.to_list(          0..(rails-1)),
                        Enum.to_list((rails-2)..1          ) )
    locations = 0..(String.length(str) - 1)
        |> Enum.to_list 
    result = List.duplicate([], rails)
    positions = railfence(locations, pattern, result)
    
    strings = String.codepoints(str)
    result = List.duplicate("_", String.length(str))
    convert(strings, positions,result)
    |> List.to_string()
  end
  def convert([], _ , result), do: result 
  def convert([hstr | tstr], [hpos | tpos], result) do 
    result = List.replace_at(result, hpos, hstr)
    convert(tstr, tpos, result)
  end

  def test do 
    msg = "WEAREDISCOVEREDFLEEATONCE"
    result = "WECRLTEERDSOEEFEAOCAIVDEN"
    encode(msg, 3) |> IO.puts
    IO.puts result
  end
  def test2 do 
    msg = "WEAREDISCOVEREDFLEEATONCE"
    result = "WECRLTEERDSOEEFEAOCAIVDEN"
    decode(result, 3) |> IO.puts
    IO.puts msg
  end
end
