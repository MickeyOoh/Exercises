defmodule OCRNumbers do
  @digitpat %{ 
    0 => [" _ ","| |","|_|","   "], 1 => ["   ","  |","  |","   "],
    2 => [" _ "," _|","|_ ","   "], 3 => [" _ "," _|"," _|","   "],
    4 => ["   ","|_|","  |","   "], 5 => [" _ ","|_ "," _|","   "],
    6 => [" _ ","|_ ","|_|","   "], 7 => [" _ ","  |","  |","   "],
    8 => [" _ ","|_|","|_|","   "], 9 => [" _ ","|_|"," _|","   "],
    }
  @digits Map.to_list(@digitpat) |> Enum.map( fn {x, y} -> {y, x} end)

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine
  which number is represented, or whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input) do
    case check_format(input) do
      {:error, msg} -> {:error, msg} 
      _lens -> 
        lines =
          Enum.chunk(input, 4)
          |> Enum.reduce( [], 
                  fn block, acc -> acc ++ convert_format(block) end)
        { :ok, set_nums(lines, "") }
    end 

  end
  def check_format([]), do: "" 
  def check_format(input) do 
    if rem(length(input), 4) == 0 do
      lens = 
        Enum.map(input, &(String.length(&1)) ) 
        |> Enum.chunk( 4)
        |> Enum.map( &(Enum.uniq(&1)) )
      lens = Enum.map(lens, fn x -> 
        if Enum.count(x) == 1 and rem(hd(x),3) == 0, 
        do: div(hd(x), 3),
        else: :error
      end)
      if Enum.any?(lens, fn(x) -> x == :error end),
        do: {:error, 'invalid column count'},
        else: lens
    else
      {:error, 'invalid line count'}
    end
  end  
  #def convert_format(block, _) when length(block) != 4,
  #  do: {:error, 'invalid line count'}
  def convert_format(block) do
      len = String.length(Enum.at(block, 0) )
      num = div(len,3)
      for n <- 0..(num-1) do
        format(block, n) 
      end
  end
  def format(ocrdt, n) do 
    n = n * 3
    Enum.reduce(ocrdt, [], fn(x, acc) -> 
      [String.slice(x, (n)..(n+2)) | acc] end)
    |> Enum.reverse() 
  end
  def set_nums([], output), do: output
  def set_nums([head | tail], output) do
    num = Enum.find(@digits, fn {v, _dig} -> v == head end)
    if num != nil do
      {_, dig} = num
      output = output <> to_string(dig) 
      set_nums(tail, output)
    else
      output = output <> "?" 
      set_nums(tail, output)
    end 
  end
  def test(pat) do 
    Map.get(@digitpat, pat)
  end
  def testnums(nums) do 
    strlist =
      String.codepoints(nums)
      |> Enum.map( fn x -> String.to_integer(x) end)
      |> Enum.map( fn n -> Map.get(@digitpat, n) end)
      #IO.inspect strlist
    Enum.map(0..3, &(testformat(strlist, &1)) ) 
  end
  defp testformat(strlist, n) do
    Enum.reduce(strlist, "", fn(x, acc) -> acc <> Enum.at(x, n) end)
  end
  def read_mappat(), do: @digitpat
  def read_digit(), do: @digits
end
