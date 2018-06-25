defmodule Say do
  @str1 %{
    1 => "one", 2 => "two",   3 => "three", 4 => "four", 5 => "five",
    6 => "six", 7 => "seven", 8 => "eight", 9 => "nine",10 => "ten",
    11 =>"eleven", 12 => "twelve", 13 => "thirteen", 14 => "fourteen",
    15 =>"fiftenn",16 => "sixteen",17 => "seventeen",18 => "eighteen",
    19 => "nineteen", 20 => "twenty", 
  }
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number)
  when number < 0 or 1_000_000_000_000 <= number,
      do: {:error, "number is out of range"} 

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) when 0 < number and number <= 20 do
    {:ok, @str1[number]} 
  end
  @str10 %{20 => "twenty",30 => "thirty", 40 => "forty", 50 => "fifty",
              60 => "sixty", 70 => "seventy",80 => "eighty",90 => "ninety"}
  def in_english(number) when 20 < number and number < 100 do
    a10 = div(number, 10) * 10
    a1  = rem(number, 10)
    {:ok, "#{@str10[a10]}-#{@str1[a1]}"}
  end
  def in_english(number) when number < 1000 and 100 <= number do
    a100 = div(number, 100)
    a10  = rem(number, 100)
    {:ok, "#{@str1[a100]} hundred#{withoutzero(a10)}"}
  end
  def in_english(number) when 1000 <= number and number < 1_000_000 do
    a1000 = div(number, 1000)
    {:ok, str1} = in_english(a1000)
    a100  = rem(number, 1000)
    {:ok, "#{str1} thousand#{withoutzero(a100)}"}
  end
  def in_english(number)
  when 1_000_000 <= number and number < 1_000_000_000 do
    a1000000 = div(number, 1_000_000)
    {:ok, str1} = in_english(a1000000)
    a1000 = rem(number, 1_000_000)
    {:ok, "#{str1} million#{withoutzero(a1000)}"}
  end
  def in_english(number)
  when 1_000_000_000 <= number and number < 1_000_000_000_000 do
    a1000000 = div(number, 1_000_000_000)
    {:ok, str1} = in_english(a1000000)
    a1000 = rem(number, 1_000_000_000)
    {:ok, "#{str1} billion#{withoutzero(a1000)}"}
  end

  def withoutzero(num) when num > 0 do
    {:ok, str} = in_english(num)
    " " <> str
  end
  def withoutzero(_), do: ""

end
