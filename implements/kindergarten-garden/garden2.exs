defmodule Garden do
  @default_names [
    :alice, :bob, :charlie, :david, :eve,
    :fred, :ginny, :harriet, :ileana, :joseph,
    :kincaid, :larry
  ]
  @letter_map %{"V" => :violets,"R" => :radishes,
                "C" => :clover,"G" => :grass}
  defstruct name: "", plants: {}

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    student_names = Enum.sort(student_names)
    row = divide_by_line(info_string) 
    pickup(row, [])
    |> Enum.with_index()
    #|> IO.inspect
    |> Enum.map( fn {v,k} -> convert(Enum.at(student_names, k), v) end)
    #|> IO.inspect
    |> List.flatten()
    |> Enum.into( %{})
    |> IO.inspect

  end
  def pickup(["", ""], lll), do: lll
  def pickup([row1, row2], lll) do 
    lst = "#{String.slice(row1, 0..1)}#{String.slice(row2,0..1)}"
    lll = lll ++ [lst] 

    row1 = String.slice(row1, 2..-1)
    row2 = String.slice(row2, 2..-1)
    pickup([row1, row2], lll)
  end
  defp convert(key, v) do
    #IO.puts "k->#{inspect key},v->#{inspect v}"
    val = String.codepoints(v)
          |> Enum.map( fn x -> Map.get(@letter_map, x) end)
          |> List.to_tuple
    Keyword.put([], key, val) 
    #|> IO.inspect 
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
