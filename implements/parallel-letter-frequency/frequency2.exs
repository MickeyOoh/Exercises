defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    groups = Enum.map(0..(workers - 1), &stripe(&1, texts, workers))

    Enum.map(groups, &Frequency.count_texts/1)
    #|> IO.inspect
    |> merge_freqs()
  end

  @doc false
  def count_texts(texts) do 
    Enum.map(texts, &count_text/1)
    |> merge_freqs()
  end
  def count_text(string) do 
    
    String.replace(string, ~r/\P{L}+/u, "")
    |> String.downcase()
    |> String.graphemes()
    #|> IO.inspect
    |> Enum.reduce( %{}, 
            fn c, acc -> 
              Map.update(acc, c, 1, &(&1 + 1)) end)
  end
  def stripe(n, texts, workers) do 
    Enum.drop(texts, n) 
    #|> IO.inspect 
    |> Enum.take_every(workers)
  end
  def merge_freqs(map) do 
    Enum.reduce(map, %{}, fn d, acc -> 
      Map.merge(acc, d, fn _, a, b -> a + b end)
      end)
  end
end
