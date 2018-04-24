defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
  end

  def white_win?(board) do 
    board 
    |> hd
    |> String.graphemes()
    |> Enum.with_index()

  end
  def testdata() do 
    [ ". O . .", 
      " O X X X",
      "  O X O .",
      "   X X O X",
      "    . O X ."]
  end
  def remove_spaces(rows) do
    Enum.map(rows, &String.replace(&1, " ", ""))
  end
end
