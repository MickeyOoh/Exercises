defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) when (letter - ?A) >= 0 and is_integer(letter) do
    pos = letter - ?A
    size = pos * 2 + 1
    loc = Enum.into(0..pos, [])
    loc = loc ++ Enum.drop(Enum.reverse(loc), 1)
    result = for row <- loc do
      List.duplicate("\s", size)
      |> List.update_at( pos - row, fn _ -> << ?A + row>> end)
      |> List.update_at( pos + row, fn _ -> << ?A + row>> end)
      |> List.insert_at( size, "\n")
      |> Enum.join()
    end
    Enum.join(result) 
  end
  def bulid_shape(letter) do
    IO.puts "Wrong letter #{inspect letter}. from ?A"
  end
  defp add_list(lst, element) do 
    lst ++ [element]
  end
end
