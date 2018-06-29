#Relationship to the affine cipher
#E(x) = D(E(x)) = ((m - 1)x + (m - 1)) mod m
#E(x) = (m - 1)(x + 1) mod m
#    =  -(x + 1)mod m
#
defmodule Atbash do
  @array Enum.zip(?a..?z, ?z..?a) |> Enum.into(%{})
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  #IO.inspect @array
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> normalize()
    |> convert() 
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    lst = Regex.replace(~r/\W/, cipher, "")
    String.to_charlist(lst)
    |> Enum.map(fn x -> Map.get(@array, x, x) end)
    |> List.to_string
    #|> IO.inspect
  end
  @doc """
  downcase(string) -> remove non-letters
  """
  @spec normalize(String.t()) :: String.t()
  def normalize(string) do 
    str = String.downcase(string)
    Regex.replace(~r/\W/, str, "")   # remove non-letters
  end
  @doc """
  
  """
  def convert(string) do
    String.to_charlist(string)
    |> Enum.map(fn x -> Map.get(@array, x, x) end)
    |> List.to_string() 
    |> chunk()
    |> Enum.join(" ") 
    #|> IO.inspect
  end 
  def chunk(input) do 
    Regex.scan(~r/.{1,5}/, input) |> List.flatten()
  end
end
