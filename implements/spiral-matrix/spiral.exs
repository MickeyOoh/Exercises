defmodule Spiral do
  @directions %{right: {+1,0},down: {0,1},left: {-1,0},up: {0,-1} }
  @dirs [:right, :down, :left, :up]
  @direcs [{+1,0},{0,1},{-1,0},{0,-1}]
  @doc """
  Given the dimension, return a square matrix of numbers in 
  clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(dimension) do
    matrix = List.duplicate(0, dimension)
             |> List.duplicate( dimension)
    nums = Enum.to_list(1..(dimension * dimension ))
    #spiral(nums, @dirs, {0,0}, matrix) 
    forward(nums, {0,0},@direcs, matrix) 
  end
  def forward([], _, _, matrix), do: matrix
  def forward([1 | t],{x,y},dirs, matrix) do
    matrix = allocate(1, {0, 0}, matrix)
    forward(t, {x,y}, dirs, matrix)  
  end
  def forward([num | t], {x,y}, [{dx,dy} | dirs], matrix) do 
    if available?({x+dx, y+dy}, matrix) do 
      new_x = x+dx
      new_y = y+dy
      matrix = allocate(num, {new_x, new_y}, matrix)
      forward(t, {new_x,new_y},[{dx,dy} | dirs], matrix)  
    else
      #IO.puts "#{num}->(#{x},#{y})-> #{inspect dirs}"
      forward([num | t],{x, y}, dirs ++ [{dx,dy}], matrix) 
    end
  end

  @spec spiral(list(), list(), any, list()) :: list()
  def spiral([], _, _, matrix), do: matrix 
  def spiral([1 | t], dirs, {x,y}, matrix) do
    matrix = allocate(1, {x, y}, matrix)
    spiral(t, dirs, {x, y}, matrix) 
  end
  def spiral([num | t],[dir | dirs], {x,y}, matrix) do  
    {dx, dy} = @directions[dir]
    #IO.puts "(#{x},#{y}) -> (#{x+dx},#{y+dy}):#{num}"
    if available?({x+dx,y+dy}, matrix) do
      matrix = allocate(num, {x+dx, y+dy}, matrix)
      spiral(t, [dir | dirs], {x+dx, y+dy}, matrix)
    else
      spiral([num | t], dirs ++ [dir], {x, y}, matrix)
    end 
  end
  def available?({pos_x, pos_y}, matrix) do 
    rows = Enum.at(matrix, pos_y)
    if rows != nil do
      Enum.at(rows, pos_x) == 0
    else
      false
    end
  end
  def allocate(num, {pos_x, pos_y}, matrix) do
    rows = 
      Enum.at(matrix, pos_y)
      |> List.replace_at( pos_x, num)
    List.replace_at(matrix,pos_y, rows)
  end
end
