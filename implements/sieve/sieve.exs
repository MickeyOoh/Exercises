defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to2(limit) do
    Enum.reduce(2..limit, [],
        fn number, primes ->
          if is_prime?(number, primes) do 
            [number | primes]
          else
            primes
          end
        end)
    |> Enum.reverse()
  end
  defp is_prime?(number, primes) do
    Enum.all?(primes, &(rem(number, &1) != 0))
  end
  def primes_to(limit) do 
    Enum.to_list(2..limit) 
    |> do_primes(  []) 
    |> Enum.reverse()
  end
  def do_primes([], primes), do: primes
  def do_primes([candidate | rest], primes) do 
    candidates = Enum.reject(rest, &(rem(&1, candidate) == 0))
    do_primes(candidates, [candidate | primes])
  end
end
