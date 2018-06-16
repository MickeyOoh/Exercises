defmodule ProteinTranslation do

  @rna %{
    "UGU" => "Cysteine", "UGC" => "Cysteine",
    "UUA" => "Leucine",  "UUG" => "Leucine",
    "AUG" => "Methionine", 
    "UUU" => "Phenylalanine", "UUC" => "Phenylalanine",
    "UCU" => "Serine", "UCC" => "Serine",
    "UCA" => "Serine", "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine", "UAC" => "Tyrosine",
  }
  @stop %{
    "UAA" => "STOP", "UAG" => "STOP", "UGA" => "STOP",
  }
  @doc """
  Given an RNA string, return a list of proteins specified by codons,
  in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    translate_rna(rna, [])
    #len = String.length(rna)
    #if rem(len, 3) == 0 do 
    #    split_n(rna, 3, [])
    #    |> Enum.map(  fn str -> @rna[str] end)
    #else
    #   {:error, "invalid RNA"}
    #end 
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}

  def of_codon(codon) do
    translate_codon(codon)
    #    case @rna[codon] do
    #  nil -> {:error, "invalid RNA"}
    #  rna   -> {:ok, rna}
    #end 
  end

  def translate_rna("", results), do: {:ok, Enum.reverse(results)}

  for {codon, code} <- @stop do 
    #IO.puts "codon->#{codon}, code ->#{code}"
    def translate_rna(unquote(codon) <> _rest, results),
      do: {:ok, Enum.reverse(results)}
    def translate_codon(unquote(codon)), do: {:ok, unquote(code)}
  end

  for {codon, protein} <- @rna  do
    #IO.puts "codon->#{codon}, protein->#{protein}"
    def translate_rna(unquote(codon) <> rest, results) do
      #IO.puts "rest->#{inspect rest}, results->#{inspect results}"
      translate_rna(rest, [unquote(protein) | results])
    end
    def translate_codon(unquote(codon)), do: {:ok, unquote(protein)}
  end 
  def translate_rna(_, _), do: {:error, "invalid RNA"}
  def translate_codon(_), do: {:error, "invalid codon"}

  def split_n("", _n, acc), do: Enum.reverse(acc)
  def split_n(codon, n, acc) do
    first = String.slice(codon, 0..n-1)
    codon = String.slice(codon, n..-1)
    acc = [first | acc]
    split_n(codon, n, acc) 
  end
  def rd_rna do 
    @rna
  end
end
