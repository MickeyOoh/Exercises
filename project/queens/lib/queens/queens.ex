defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: {7, 3}, white: {0, 3}

  import Queens.Server
  def init() do 
    board = generate_board()
    start_link(board)
  end

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()

  def new(same, same), do: raise(ArgumentError)
  #def new({wx, wy},_)
  #when wx < 0 or wy >= 8 or wy < 0 or wy >= 8,
  #   do: raise(ArgumentError)
  #def new(_,{bx, by})
  #when bx < 0 or 8 <= bx or by < 0 or 8 <= by,
  #   do: raise(ArgumentError)

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
    IO.puts "w->#{inspect white},b->#{inspect black}"
    board =
      Queens.Server.update(generate_board()) 
      |> update_pos( white, "W")
      |> update_pos( black, "B")
      |> IO.inspect
      |> Queens.Server.update()
      |> IO.inspect
      #print = Enum.map(board, fn x -> Enum.join(x, " ") end)
      Enum.map(board, &Enum.join(&1," "))
      |> Enum.join("\n") 
  end
  def update_pos(board, {x, y}, char) do 
    xdata = 
      Enum.at(board, x)
      |> List.replace_at( y, char)
    board = List.replace_at(board, x, xdata) 
    #Queens.Server.update(board)
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

  def generate_board do 
    "_"
    |> List.duplicate(8)
    |> List.duplicate(8)
  end
end
