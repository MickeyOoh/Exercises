defmodule Wordy do
  @operands   [Wordy.Number]
  @operations [Wordy.Addition, Wordy.Subtraction,
               Wordy.Multiplication, Wordy.Division]
  @parts @operands ++ @operations

  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    question
    |> tokenize
    |> parse
    |> validate
    |> calculate
  end

  defp tokenize(sentence) do
    #Regex.scan(~r/(#{all_matchers()})/, sentence)
    #|> Enum.map(&Enum.at(&1, 0))
    Regex.scan(~r/#{all_matchers()}/, sentence)
    |> List.flatten
  end
  defp all_matchers do
    Enum.map(@parts, & &1.matcher) |> Enum.join("|")
  end

  defp parse(tokens) do
    for token <- tokens, part = Enum.find(@parts, & &1.match?(token)) do
      part.parse(token)
    end
    #|> IO.inspect
  end

  defp validate(parsed) do
    if Enum.find(parsed, &is_function(&1)) do
      parsed
    else
      raise ArgumentError
    end
  end

  defp calculate([left | []]), do: left

  defp calculate([left, operation, right | t]) do
    calculate([operation.(left, right) | t])
  end

  defmodule Number do
    def matcher, do: "-?\\d+"
 
    def match?(token), do: String.match?(token, ~r/#{matcher()}/)
    
    def parse(token),  do: String.to_integer(token)
  
  end

  defmodule Addition do
    def matcher, do: "plus"

    def match?(token), do: String.match?(token, ~r/#{matcher()}/)

    def parse(_), do: &calculate/2

    def calculate(left, right), do: left + right
  end

  defmodule Subtraction do
    def matcher, do: "minus"

    def match?(token), do: String.match?(token, ~r/#{matcher()}/)

    def parse(_), do: &calculate/2

    def calculate(left, right), do: left - right
  end

  defmodule Multiplication do
    def matcher, do: "multiplied by"

    def match?(token), do: String.match?(token, ~r/#{matcher()}/)

    def parse(_), do: &calculate/2

    def calculate(left, right), do: left * right
  end

  defmodule Division do
    def matcher, do: "divided by"

    def match?(token), do: String.match?(token, ~r/#{matcher()}/)

    def parse(_), do: &calculate/2

    def calculate(left, right), do: round(left / right)
  end
end
