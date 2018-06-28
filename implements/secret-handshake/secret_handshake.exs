defmodule SecretHandshake do
  use Bitwise

  #@codes ["jump", "close your eyes", "double blink", "wink"] 
  @codes ["wink", "double blink","close your eyes","jump"] 

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
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    #<<a::1,b::1,c::1,d::1,e::1>> = << code::5>>
    #<<bits::8>> = <<e::1,d::1,c::1,b::1,a::1,0::3>>
    #IO.inspect bits
    @codes
    |> Enum.with_index()
    |> Enum.map( fn {str, i} -> {str, 2 <<< (i - 1)} end)
    |> decode( code, []) 
  end
  def decode([], code, results) do
    #case flag_chk(code, 0x10) do 
    case flag_chk(code, 0b10000) do 
      true -> results
      _  -> Enum.reverse(results)
    end
  end 
  def decode([{str, flag} | flags], code, results) do
    case flag_chk(code, flag) do 
      true -> decode(flags, code, [str | results])
      _    -> decode(flags, code, results) 
    end
  end 

  def flag_chk(flags, chkflag), do: (flags &&& chkflag) == chkflag  
end
