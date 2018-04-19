defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.
    1.Set low to 0 and high to n -1
    2.if low > high, the search terminates as unsuccessful
    3.Set m(the poistion of the middle element) to the floor
      (the largest previous integer) of (low + high)/2.
    4.if Am < T, set low to m + 1 and go to step 2
    5.if Am > T, set high to m -1 and go to step 2
    6.Now Am = T, the search is done; return m.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _key), do: :not_found
  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers) - 1) 
  end
  def do_search(_numbers, _key, low, high) when high < low do
    :not_found
  end
  def do_search(numbers, key, low, high) do
    #mid = trunc((low + high)/2)
    mid = div(low + high, 2)
    dat = elem(numbers, mid)
    cond do 
      dat < key  ->
          low = mid + 1
          do_search(numbers, key, low, high)
      dat > key  ->
          high = mid - 1
          do_search(numbers, key, low, high)
      #dat == key -> {:ok, mid}
      true -> {:ok, mid}
    end
  end
end
