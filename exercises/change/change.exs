defmodule Change do
  @test_data 21
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
    #|> check_change( target, [])
    |> check( target, [])
  end
  def bestone([]), do: {:error, "cannot change"} 
  def bestone( r_list) do 
    best = Enum.min_by(r_list, fn(x) -> length(x) end) 
    {:ok, best}
  end
  def check([], _, r_list) do
    r_list
  end
  def check( [coin | coins], target, r_list) do 
    { ret, result} = check_change([coin | coins], target, [])
    IO.puts "check-> #{inspect ret},#{inspect result}"
    if ret == :ok do
      r_list = r_list ++ [result]
      check(coins, target, r_list) 
    else 
      check(coins, target, r_list)
    end
  end 

  def check_change(_, 0, result) , do: {:ok, result}
  def check_change([], _, _) , do: {:error, "cannot change"}
   
  def check_change([coin | coins], target, result) when coin > target do
    check_change(coins, target, result)
  end

  def check_change([coin | coins], target, result) do  
    IO.puts "h:#{coin} sum:#{target}, res:#{inspect result}"
    #target = target - coin 
    #result = [coin] ++ result
    check_change([coin | coins], target - coin, [coin] ++ result)
    #check_change(coins, target, result) 
  end
  @test_coins [2,5,10,20,50]
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
