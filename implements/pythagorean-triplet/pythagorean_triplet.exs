defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    Enum.reduce(triplet, 0, &(&1 + &2))
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    Enum.reduce(triplet, 1, &(&1 * &2))
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    a * a + b * b == c * c
  end

  #def select?(triplet) do 
  #  pythagorean?(triplet)
  #end
  #def select?(triplet, sum) do 
  #  pythagorean?(triplet) 
  #end
  @doc """
  Generates a list of pythagorean triplets from a given min 
  (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer)
                   :: [list(non_neg_integer)]
  def generate(min, max) do
    for x <- Enum.to_list(min..max),
        y <- Enum.to_list(x..max),
        z <- Enum.to_list(y..max),
        pythagorean?([x, y, z]) do
          [x, y, z]
    end
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to 
  a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer)
                       :: [list(non_neg_integer)]
  def generate(min, max, sum) do
    for x <- Enum.to_list(min..max),
        y <- Enum.to_list(x..max),
        z <- Enum.to_list(y..max),
        pythagorean?([x, y, z]) && sum([x,y,z]) == sum do
          [x, y, z]
    end
  end
end
