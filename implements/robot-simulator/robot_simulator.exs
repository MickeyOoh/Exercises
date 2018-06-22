defmodule RobotSimulator do
  defstruct direction: nil, position: nil

  @valid_directions [:north, :east, :south, :west]
  @forward [north: {0,1},east: {1, 0}, south: {0,-1}, west: {-1, 0} ]
  @backward [north: {0,-1},east: {-1, 0}, south: {0,1}, west: {1, 0} ]
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0,0}) do
    %RobotSimulator{} 
    |> place( position) |> orient( direction) 
  end
  defp place(%RobotSimulator{}=robot, {x, y} = position) 
  when is_integer(x) and is_integer(y) do
    %{robot | position: position}
  end
  defp place(_, _), do: {:error, "invalid position"}

  defp orient(%RobotSimulator{} = robot, direction) 
  when direction in @valid_directions do
    %{robot | direction: direction}
  end
  defp orient({:error, _} = error, _), do: error
  defp orient(_,_), do: {:error, "invalid direction"}

  #def rotate_right(dir, [h | t]) when dir == h, do: hd(t)
  #def rotate_right(dir, [h | t]), do: rotate_right(dir, t ++ [h])  

  #def rotate_left(dir, [h | t]) when dir == h, do: List.last(t)
  #def rotate_left(dir, [h | t]), do: rotate_left(dir, t ++ [h])  

  for [curr, right] <- @valid_directions
                       |> Stream.cycle()
                       |> Enum.take(5)
                       |> Enum.chunk(2, 1) do
    defp rotate_right(unquote(curr)), do: unquote(right)
    defp rotate_left(unquote(right)), do: unquote(curr)
  end
  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), 
  and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    String.codepoints(instructions)
    |> Enum.reduce(  robot, fn x, acc -> move(x, acc) end)
  end

  def move("R", %RobotSimulator{} = robot) do
    #dir = rotate_right(direction(robot), @valid_directions)
    dir = rotate_right(direction(robot))
    %{robot | direction: dir} 
  end
  def move("L", %RobotSimulator{} = robot) do
    dir = rotate_left(direction(robot))
    %{robot | direction: dir} 
  end
  def move("A", %RobotSimulator{} = robot) do
    dir = direction(robot)
    {x,y} = position(robot)
    {xx, yy} = @forward[dir]
    %{robot | position: {x + xx, y + yy}} 
  end
  def move("B", %RobotSimulator{} = robot) do
    {x,y} = position(robot)
    {xx, yy} = @backward[direction(robot)]
    %{robot | position: {x + xx, y + yy}} 
  end
  def move(_, {:error, _} = error), do: error
  def move(_,_), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%RobotSimulator{direction: dir}), do: dir

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%RobotSimulator{position: pos}), do: pos

end
