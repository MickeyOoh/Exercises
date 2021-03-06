defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @invalid "0000000000"
  @regs %{:brace  => ~r/[().\s+-]+/, 
          :letter => ~r/[A-za-z]+/,
          :allletter => ~r/\P{L}+/u,
          :phone_num => ~r/^1?(?:[2-9][0-9]{2}){2}\d{4}$/,
          :allnumber => ~r/\P{N}+/,
            }
  #@format [1,3,3,4]
  #@len Enum.sum(@format)
  @spec number(String.t()) :: String.t()
  def number(raw) do 
    raw
      |> String.replace(@regs[:brace], "")
      |> valid?()
    #|> (fn
    #     false -> @invalid
    #     num   -> String.replace(num, ~r/^1/, "")
    #  end).()
      |> case do
           false -> @invalid
           num -> String.replace(num, ~r/^1/, "")
         end 
  end 
  def valid?(num) do
    Regex.match?(@regs[:phone_num], num)
    #|> (fn
    #     true  -> num
    #     false -> false 
    #   end).()
    |> case do 
      true -> num
      false -> false
    end
  end
  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    raw
    |> __MODULE__.number()
    |> String.slice( 0, 3)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    code =
      raw
      |> __MODULE__.number()
    <<area_code::binary-size(3),
      exchange_code::binary-size(3),
      rest::binary>> = code
    "(#{area_code}) #{exchange_code}-#{rest}"
  end
end
