defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: {7, 3}, white: {0, 3}

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()

  def new(same, same), do: raise(ArgumentError)

  def new(white, black) do
    %Queens{white: white, black: black}
  end
  def new(), do: %Queens{}

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  #def to_string(queens) do
  def to_string(%Queens{white: white, black: black}) do
      generate_board()
      |> update_pos( white, "W")
      |> update_pos( black, "B")
      #|> IO.inspect 
      |> Enum.map(  &Enum.join(&1, " "))
      |> Enum.join( "\n") 
  end
  def update_pos(board,{x, y}, char) do 
    xdata = Enum.at(board, x)
    xdata = List.replace_at(xdata, y, char)
    List.replace_at(board, x, xdata) 
  end
  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: white, black: black}) do
    {wx, wy} = white
    {bx, by} = black
    wx == bx || wy == by || abs(wx - bx) == abs(wy - by)
  end
  #defp diagonal?({x1,y1}, {x2, y2}) do 
  #  abs(x1 - x2) == abs(y1 - y2)
  #end
  def generate_board do 
    "_"
    |> List.duplicate(8)
    |> List.duplicate(8)
  end
end
