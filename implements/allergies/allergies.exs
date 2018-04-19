defmodule Allergies do
  @allergies_list ~w[
    eggs
    peanuts
    shellfish
    strawberries
    tomatoes
    chocolate
    pollen
    cats
  ]
  #IO.puts "==allergies list=="
  #Enum.each(@allergies_list, &(IO.puts &1) )
  #IO.puts "------------------"

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    bits = Integer.digits(flags, 2) |> Enum.reverse()
    Enum.with_index(@allergies_list) 
    |> Enum.filter(fn {_, index} ->
         Enum.at(bits,index) != 0 and length(bits) > index end
        )
    |> Enum.map(fn {str, _} -> str end)
  end
  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    lst = list(flags)
    Enum.member?(lst, item)
  end
end
