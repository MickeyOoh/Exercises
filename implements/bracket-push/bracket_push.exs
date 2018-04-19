defmodule BracketPush do
  @brackets %{ "{" => "}", "(" => ")", "[" => "]" }
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @regex ~r/[^\{\}\[\]\(\)]/
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    # extract all characters execept brackets 
    str
    |> String.replace(@regex, "")
    |> String.codepoints()      # string to code array
    #|> IO.inspect
    |> check([])
    #|> IO.inspect
  end
  def check([], []), do: true
  def check([], _),  do: false
  def check([h | t], acc) do 
    #IO.puts "#{h} acc:#{inspect acc}"
    cond do
      Map.has_key?(@brackets, h) ->
        bracket_list = Map.get(@brackets, h)
        check(t, [bracket_list | acc])
      Enum.empty?(acc) and !Map.has_key?(@brackets, h) ->
        false
      h != hd(acc) ->
        false
      h == hd(acc) ->
        check(t, tl(acc))
      true ->
        true
    end
  end
  def read_brackets(), do: @brackets 
end
