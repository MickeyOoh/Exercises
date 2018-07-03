defmodule Sublist do
  
  @doc """
  Returns whether the first list is a sublist or a superlist of the 
  second list and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    a_cnt = length(a)
    b_cnt = length(b)
    cond do
      a == b -> :equal
      a_cnt < b_cnt ->
        if diff_ab(a,b), do: :sublist, else: :unequal
      true   ->
        if diff_ab(b,a), do: :superlist, else: :unequal
    end
  end

  def diff_ab([], _ ), do: true
  def diff_ab(a, b) when length(a) > length(b), do: false
  def diff_ab(a, b = [_ | tb]) do 
    #IO.puts "diff_ab(#{inspect a},#{inspect b})"
    if chk_list(a,b) do
      true
    else
      diff_ab(a, tb) 
    end 
  end
  def chk_list([], _), do: true
  def chk_list([ha | ta],[hb | tb]) do
    if ha === hb do
      chk_list(ta, tb)
    else
      false
    end
  end 
  def chk_list(_,_), do: false
  
  @a_list [1,2,1,2,3]
  @b_list [1,2,3,1,2,3,2,3,2,1]
  @b_ok   [1,2,3,1,2,1,2,3,2,1]
  def test do 
    result = compare(@a_list, @b_ok)
    IO.puts "test -> #{inspect result}"
    result = compare(@a_list, @b_list)
    IO.puts "test -> #{inspect result}"
  end
end
