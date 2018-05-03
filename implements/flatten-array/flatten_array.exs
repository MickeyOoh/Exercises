defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    do_flatten(list,[])
  end
  # end of flatten, return back
  def do_flatten([], rlist) do 
    rlist
  end
  # if head is List, then call do_flatten again
  def do_flatten([head | tail], rlist) 
  when is_list(head) do
    do_flatten(head, do_flatten(tail, rlist))
  end
  # if head is nil, remove nil from list
  def do_flatten([nil | tail], rlist) do 
    do_flatten(tail, rlist)
  end
  # if head is not List, add List as head and flatten tail parts
  def do_flatten([head | tail], rlist) do 
    [head | do_flatten(tail, rlist)]
  end
  def test1() do
    FlattenArray.flatten([1, [2, nil, 4], 5]) 
    |> IO.inspect 
  end
end
