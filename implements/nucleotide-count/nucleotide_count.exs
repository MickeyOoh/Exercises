defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a NucleotideCount strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide)
  when nucleotide in @nucleotides do
    #Enum.count(strand, fn(x) -> x == nucleotide end)
    Enum.count(strand, &(&1 == nucleotide) )
  end
  def count(_starnd, _), do: raise(ArgumentError)
  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    Enum.reduce(@nucleotides, %{}, 
      fn(x, acc) -> 
         Map.put(acc, x, count(strand,x)) end)
    map = Enum.map(@nucleotides, &{&1, count(strand, &1)})
    Enum.into(map, %{})  
  end
end
