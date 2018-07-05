defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @chkregex ~r/-?\d+|plus|minus|multiplied by|divided by/
  @nums   ~r/-?\d+/
  @spec answer(String.t()) :: integer
  def answer(question) do
    Regex.scan(@chkregex, question)
    |> List.flatten
    |> parse( )
    |> calculate()
  end
  def parse(opes) when length(opes) >= 3 do
    results =
      Enum.map(opes, fn x -> 
        case Integer.parse(x) do 
          :error -> x
          {n, _} -> n
        end
      end)
    chk =
      Enum.reduce(results, 0, fn x,acc -> 
         if is_integer(x) do 
           acc + 1
         else
           acc - 1
         end
        end)
    if chk == 1, do: results, else: raise ArgumentError 
  end
  def parse(_), do: raise ArgumentError
  def calculate([results | []]) do
    results
  end
  def calculate([x, ope, y | t]) 
  when is_integer(x) and is_integer(y) do 
    results = 
      case ope do 
      "plus"  -> x + y
      "minus" -> x - y
      "multiplied by"  -> x * y
      "divided by"     -> round(x/y)
      _    -> raise ArgumentError
      end
    #IO.puts "r:#{results} t:#{inspect t}"
    calculate( [results | t])
  end
  def calculate(_),do: raise ArgumentError

  def rdregex do
    @chkregex
  end
  def test do 
    question = "what is -3 plus 7 multiplied by -2?"
    answer(question)
    |> IO.inspect
  end

end
