defmodule Permutation do 
  def permutations([]), do: [[]] 
  def permutations(list) do 
    for h <- list,
        t <- permutations(list --[h])
    do 
      [h | t]
    end
    #for h <- list do
    #  IO.puts "list:#{inspect h}"
    #  for t <- permutations(list --[h]) do 
    #    IO.puts "     h:#{inspect h},t:#{inspect t}"
    #    [h | t]
    #  end
    #end
  end
  @doc """
  これは、Sに含まれる文字を1つ順列Tに付け加え新たなNum文字からなる順列Tを
  作るものです。
  ここで、最初、Sは使う文字すべての集合、Tは空の順列を表すとすると、
  Permutation(S, T, 1)
  は樹形図の第1ステップを行うものとし、1個の元からなる順列を作った後、
  その各々の順列に対して
  Permutation(S, T, 2)
  を実施し、この処理を以下同様に繰り返し、rが求める順列の長さとすると、
  Permutation(S, T, r + 1)
  となると終了です。

  Sub Permutation(S, T, Num)
    if Num=r+1 then
      順列作成終了: 結果の書き出し
    else
      Sの各文字Chに対して、TにChを付け加えてできる順列をT1, 
      SからChを取り除いた文字の集合をS1として、
      Permutatin(S1, T1, Num + 1)を実行する。
    end
  end
  """


  def perm([],_t, _num), do: [[]]
  def perm(list) when length(list) == 1, do: [list]

  def perm(list) do
    n = length(list) - 1
    Enum.flat_map(0..n, fn index ->
      value = Enum.at(list, index)
      perm(list.delete_at(list, index))
      |> Enum.map(&([value | &1]))
    end)
  end  
  
  def perm([],_t, _num), do: [[]]
  def perm([head | rest], t, num) do
    
        
  end

  @dt [1,2,3]
end
