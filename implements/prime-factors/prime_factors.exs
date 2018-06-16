defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
   div_num(number, 2, []) 
  end
  def div_num(1, _, _factors), do: []
  def div_num(num, divisor, factors)
    when num < divisor * divisor, do: Enum.reverse(factors, [num])
  def div_num(num, divisor, factors)
    when rem(num, divisor) == 0 do 
       div_num(div(num, divisor), divisor, [divisor | factors])
  end
  def div_num(num, divisor, factors) do
   div_num(num, divisor + 1, factors)
  end
    
  def prime_to(limit) do 
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
  def is_prime?(number, primes) do 
    Enum.all?(primes, &(rem(number,&1) != 0))
  end
  def gcd_euclid(u, v) when v == 0, do: u

  def gcd_euclid(u, v) do
    #r = rem(u, v)
    #u = v
    #v = r
    #gcd_euclid(u, v)
    gcd_euclid(v, rem(u, v)) 
  end
    
end
