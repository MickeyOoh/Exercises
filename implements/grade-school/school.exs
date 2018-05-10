defmodule School do
  defstruct grade: nil, name: []
  @moduledoc """
  Simulate students in a school.
  Each student is in a grade.
  """
  #@db %School{}
  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(db, name, grade) do
    #Map.update(db, grade, [name], &[name | &1])
    if Map.has_key?(db, grade) do
      Map.replace!(db, grade, [name | Map.get(db, grade)])
    else
      Map.put(db, grade,[name]) 
    end
  end
  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(db, grade) do
    #map.get(db, grade, []) 
    val = Map.get(db, grade)
    if val != nil do 
      val
    else
      db = Map.put(db, grade, [])
      Map.get(db, grade)
    end 
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t()]}]
  def sort(db) do
    db
    |> Enum.map(fn {k, v} -> {k, Enum.sort(v)} end)
    |> Enum.sort()
  end
end
