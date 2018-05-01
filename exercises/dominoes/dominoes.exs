defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true
  def chain?([{a, a}]), do: true
  def chain?([{_a, _b}]), do: false
  def chain?(dominoes) do
    #IO.puts "dominoes:#{inspect dominoes}"
    result = chains(dominoes)
    #IO.puts "result:#{inspect result}=>#{inspect [] !== result}"
    [] !== result
    #[] !== chains(dominoes)
  end
  def chains([first | rest]) do 
    for combi         <- permutations(rest),
        {:ok, result} <- chain(combi, [], first) do
        result
    end      
  end 

  defp chain([], [{a, _} | _] = acc, {_, a} = last) do
    #IO.puts "chain1 -> #{inspect acc} ++ [#{inspect last}]"
    [{:ok, acc ++ [last]}]
  end
  defp chain([], _acc, _last) do
    #IO.puts "[{:error, :ends_not_same}]"
    [{:error, :ends_not_same}]
  end
  # b != c
  # {b, c} of first, next {_, y}) -> b == y 
  defp chain([{b, c} | rest], acc, {_, b} = next) 
  when b != c do
    #IO.puts "chain3 -> #{inspect {b,c}},acc:#{inspect acc},next:#{inspect next}"
    chain(rest, acc ++ [next], {b, c})
  end
  # {b, c} of first, next {_, y}) -> c == y 
  defp chain([{c, b} | rest], acc, {_, b} = next) 
  when b != c do
    #IO.puts "chain4 -> #{inspect {c,b}},acc:#{inspect acc},next:#{inspect next}"
    #IO.puts "       rest:#{inspect rest}"
    chain(rest, acc ++ [next], {b, c})
  end
  defp chain([{b, b} = this | rest], acc, {_, b} = next) do 
    #IO.puts "chain5 -> #{inspect this},acc:#{inspect acc},next:#{inspect next}"
    chain(rest, acc ++ [next], this)
  end
  defp chain(_a, _b, _c) do
    #IO.puts "[{:error, :no_followup}]"
    [{:error, :no_followup}]
  end
  def permutations([]), do: [[]]
  def permutations(list) do
    #IO.puts "list:#{inspect list}"
    for h <- list,
        t <- permutations(list -- [h]) do
      #IO.puts "        #{inspect h} | #{inspect t}"
      [h | t]
    end    
  end
  @testdt [{1,2}, {1,3}, {2,3}]
  def test1() do 
    #permutations(@testdt)
    chain?(@testdt)
  end
  def rdtest(), do: @testdt
  def test2() do 
    chain?([{1, 2}, {2, 3}, {3, 1}, {2, 4}, {2, 4}])
  end
end
