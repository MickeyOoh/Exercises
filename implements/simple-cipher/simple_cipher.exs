defmodule SimpleCipher do
  @alphabet 'abcdefghijklmnopqrstuvwxyz'
  @alphabet_size length(@alphabet)
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext
  by shifting it by the corresponding letter in the alphabet shifted 
  by the number of letters represented by the `key` character, 
  repeating the `key` if it is shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and 
  mapping it to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet 
  of the `key`
  character in the same position. If the `key` is shorter than the `
  plaintext`, repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key) do
    strings = String.to_charlist(plaintext)
    keycode = String.to_charlist(key) 
    encoding(strings, keycode, [])
    |> Enum.join()
  end

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    decoding(String.to_charlist(ciphertext),
             String.to_charlist(key), [])
    |> Enum.join()
  end

  def encoding([], _, results), do: Enum.reverse(results)
  def encoding([char | rest],keys, results) 
  when char < ?a or char > ?z do 
    str = List.to_string([char])
    encoding(rest, keys, [ str | results]) 
  end 
  def encoding([char | rest], [key | keys], results)
  when char + key - ?a > ?z do
    str = List.to_string([<< char + key  - (?z + 1) >>])
    encoding(rest, keys ++ [key], [str | results]) 
  end
  def encoding([char | rest], [key | keys], results) do
    str = List.to_string([<< char + key - ?a>>])
    encoding(rest, keys ++ [key], [str | results])
  end

  def decoding([], _, results), do: Enum.reverse(results)
  def decoding([char | rest], keys, results)
  when char < ?a or char > ?z do
    str = List.to_string([<<char>>]) 
    decoding(rest, keys, [str | results])
  end
  def decoding([char | rest], [key | keys], results)
  when char - key >= 0 do
    str = List.to_string([<< char - (key - ?a) >>])
    decoding(rest, keys ++ [key], [str | results]) 
  end
  def decoding([char | rest], [key | keys], results) do
    str = List.to_string([<< char - key + (?z + 1) >>])
    decoding(rest, keys ++ [key], [str | results])
  end
  #def transcodes(key) do
  #  @alphabet
  #  |> Kernel.<>(@alphabet)
  #  |> String.split( "", trim: true)
  #  |> Enum.drop(shift)
  #  |> Enum.take(@alphabet_size) 
  #   
  #end
  def test() do 
    key       = "supersecretkey" 
    plaintext = "attackxatxdawn"
    keys = String.split(key, "", trim: true)
    plaintexts = String.split(plaintext, "", trim: true)
    testsigle(plaintexts, keys, [])
  end
  def testsigle([],_, results), do: Enum.reverse(results)
  def testsigle([h | t], [kh | kt], results) do 
    str = encode(h, kh)
    testsigle(t, kt, [str | results])
  end
end
