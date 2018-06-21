defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  #@tran %{?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U}
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    #Enum.map(dna, &transit(@tran[&1]) )
    Enum.map(dna, &transcribe(&1))
  end
  def transit(char) when char == nil, do: '?'
  def transit(char), do: char 

  defp transcribe(?G), do: ?C
  defp transcribe(?C), do: ?G
  defp transcribe(?T), do: ?A
  defp transcribe(?A), do: ?U
  defp transcribe(_),  do: ??
end
