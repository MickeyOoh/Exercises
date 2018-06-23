defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")         #  
    |> Enum.map( &coordinate(&1))   # line to list be two dimension
  end
  def coordinate(strlist) do 
    String.split(strlist, " ", trim: true)
    |> Enum.map(  &String.to_integer(&1))
  end
  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rows = rows(str)
    columns = columns(str)
    pos =
      for x <- Enum.to_list(0..(length(rows)-1)),
          y <- Enum.to_list(0..(length(columns)-1)) do 
            {x,y}
      end 
   Enum.filter(pos, &is_saddle_point?(&1, rows, columns) ) 
  end
  
  def is_saddle_point?(point, rows, columns) do 
    max_in_row?(point, rows) && min_in_column?(point, columns)
  end
  def max_in_row?({x, y}, rows) do 
    row = Enum.at(rows, x)
    Enum.at(row,y) == Enum.max(row)
  end
  def min_in_column?({x, y}, columns) do 
    column = Enum.at(columns, y)
    Enum.at(column,x) == Enum.min(column)
  end
  def set_pos(rows) do 
    Enum.with_index(rows) 
    #|> Enum.map( fn {row, y} -> Enum.map(r w, fn  
  end
  def generate_coordinates(rows) do 
    rows
    |> Enum.with_index()
    |> Enum.flat_map(&generate_coordinates_row/1)
  end
  def generate_coordinates_row({row, row_index}) do 
    row
    |> Enum.with_index()
    |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
  end
  def testdt do 
   "1 2 3\n4 5 6\n7 8 9\n8 7 6"
  end
end
