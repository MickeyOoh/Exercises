defmodule Garden do
  @default_names [
    :alice, :bob, :charlie, :david, :eve,
    :fred, :ginny, :harriet, :ileana, :joseph,
    :kincaid, :larry
  ]
  @letter_map %{"V" => :violets,"R" => :radishes,
                "C" => :clover,"G" => :grass}
  #defstruct name: "", plants: {}

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    row = divide_by_line(info_string) 

    plants = pickup(row, [])
             |> convert( [])

    student_names = Enum.sort(student_names)
    create_map(student_names, plants)   #%{name1: {},name2: {}}
    #|> IO.inspect 
  end
  #@spec create_map(List, List) :: map
  defp create_map(student_names, plants) do 
    _create_map(student_names, plants, %{})
  end
  defp _create_map([], _plants, map), do: map
  defp _create_map([h | t], [], map)  do
    map = Map.put(map, h, {})
    _create_map(t, [], map)
  end  
  defp _create_map([h | t], [hp | tp], map) do
    map = Map.put(map, h, hp)
    _create_map(t, tp, map)
  end

  def pickup(["", ""], lll), do: lll
  def pickup([row1, row2], lll) do 
    lst = "#{String.slice(row1, 0..1)}#{String.slice(row2,0..1)}"
    lll = lll ++ [lst] 

    row1 = String.slice(row1, 2..-1)
    row2 = String.slice(row2, 2..-1)
    pickup([row1, row2], lll)
  end
  defp convert([], plants), do: plants
  defp convert([h | t], plants) do
    tup = String.codepoints(h)
          |> Enum.map( fn x -> Map.get(@letter_map, x) end)
          |> List.to_tuple
    plants = plants ++ [tup]
    convert(t, plants)
  end 

  defp divide_by_line(info_string) do 
    row = String.split(info_string, "\n")
    if length(row) == 2 do
      [row1, row2] = row
      if String.length(row1) == String.length(row2) do
        if rem(String.length(row1), 2) == 0 do 
          [row1, row2]
        else
          []
        end
      else
        []
      end
    else
      [] 
    end
  end 
  def readname() do 
    @default_names
  end
end
