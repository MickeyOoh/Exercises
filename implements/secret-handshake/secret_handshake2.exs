defmodule SecretHandshake do

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @strings ["jump", "close your eyes", "double blink", "wink"] 
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    <<reverse::1,jump::1,close::1,dblink::1,wink::1>> = <<code::5>>
    result = [jump,close,dblink,wink]
    |> Enum.with_index()
    |> Enum.reduce( [], 
            fn {x,n}, acc ->
                  if x == 1, do: [Enum.at(@strings, n) | acc], else: acc
            end)
    output(reverse, result) 
  end
  def output(1, result), do: Enum.reverse(result)
  def output(0, result), do: result
end
