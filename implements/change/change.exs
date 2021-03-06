defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    #coins_rv = Enum.sort(coins, &(&1 > &2))
    Enum.sort(coins, &>/2)
    |> check_change( target, [], [])
    #|> IO.inspect
    |> set_ret()
  end
  def set_ret([]), do: {:error, "cannot change"} 
  def set_ret([0]), do: {:ok, []} 
  def set_ret(r_list), do: {:ok, r_list}
  
  def check_change([], _,     _, r_list), do: r_list
  #def check_change( _, 0,result, r_list), do: r_list ++ [result]
  def check_change( _, 0,result, r_list) do 
    if length(result) < length(r_list) or Enum.empty?(r_list) do
      if Enum.empty?(result), do: [0], else: result
    else 
      r_list
    end
  end
  def check_change(_,_, result, r_list) 
  when length(result) > length(r_list) and r_list != [] do
    #IO.puts "length(#{inspect result}) > length(#{inspect r_list})"
    r_list
  end
  def check_change([coin | coins],target,result,r_list) when coin > target do 
    check_change(coins, target, result,r_list)
  end
  def check_change([coin | coins], target, result, r_list) do  
    #IO.puts "#{inspect [coin | coins]},#{target},#{inspect result}, #{inspect r_list}"
    r_lt = check_change([coin | coins], target - coin, [coin] ++ result, r_list)
    check_change(coins, target, result, r_lt)
  end
  @test_coins [1, 5, 10, 21, 25]
  #@test_data 63
  @test_data 0
  @test_coins2 [1, 5, 10, 25, 100]
  def test_sample  do
    IO.puts "generate(#{inspect @test_coins}, #{@test_data})"
    generate(@test_coins, @test_data)
    |> IO.inspect
  end
  def test_sample2 do 
    generate(@test_coins2, 15)
    |> IO.inspect
  end
end
