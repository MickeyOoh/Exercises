defmodule RotationalCipher do
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  @alphabet_size String.length(@alphabet)
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    plain = @alphabet |> Kernel.<>( String.upcase(@alphabet)) 
            |> String.split( "", trim: true)
    cipher = 
      @alphabet
      |> Kernel.<>(@alphabet)
      |> String.slice( shift..-1)
      |> String.slice( 0, @alphabet_size)
      |> add_upcase()
      |> String.split("", trim: true)
      #|> Enum.drop(shift)
      #|> Enum.take(@alphabet_size)
      #|> IO.inspect 
    codes = Enum.zip(plain, cipher)
    texts = String.codepoints(text)
    Enum.map(texts,fn char -> get_cipher(char, codes) end)
    |> to_string()

  end
  defp add_upcase(letters), do: letters <> String.upcase(letters) 

  def get_cipher(char, codes) do
    Enum.find(codes, fn {p, _} -> char == p end)
    |> case do 
          nil -> char
          {_, code} -> code
       end
  end
end
