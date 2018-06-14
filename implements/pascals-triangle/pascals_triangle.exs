defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  (n:k) = (n-1:k-1) + (n-1:k)
  """
  @spec rows(integer) :: [[integer]]
  #def rows(num) do
  #  Enum.reduce(0..(num - 1), [], 
  #      fn k, n_list ->
  #        k_list = get_k(k, List.last(n_list))
  #        Enum.into([k_list], n_list) end) 
  #end
  def rows(num) do 
    Enum.reduce(1..num, [], 
        fn _k, n_list ->
          k_list = set_k(List.last(n_list))
          Enum.into([k_list], n_list) end) 
  end
  def set_k(nil), do: [1]
  def set_k(n_list) do
    n_list = [0] ++ n_list ++ [0] 
    get_klist(n_list, [])
  end
  #def get_k(0, _), do: [1]
  #def get_k(_k, n_list) do 
  #  n_list = [0] ++ n_list ++ [0] 
  #  get_klist(n_list, [])
    #Enum.map(0..k,
    # (n-1:k) + (n-1: k + 1)
    #     fn nk -> Enum.at(n_list,nk) + Enum.at(n_list,nk+1)
    #     end)
  #end
  #def get_klist([], _), do: [1]
  def get_klist([h | [k | []]], k_list) do
    k_list = [h + k | k_list] 
    Enum.reverse(k_list)
  end 
  def get_klist([h | [k | t]], k_list) do 
    k_list = [h + k | k_list] 
    get_klist([ k | t], k_list)
  end
end
