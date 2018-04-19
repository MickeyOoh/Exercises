defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  #def abbreviate(string) do
  #	str = String.split(string, " ")
  #	str = str |> Enum.map( 
  #    fn x -> String.first(x) |> String.upcase end)
  #  List.to_string(str)
  #end
  def abbreviate(string) do
    Regex.scan(~r/[A-Z]+[a-z]*|[a-z]+/, string)
    |> List.flatten()
    |> Enum.map(fn x -> String.first(x) end)
    |> Enum.join("")
    |> String.upcase()
  end
end
