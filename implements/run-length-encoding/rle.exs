defmodule RunLengthEncoder do
  @reg ~r/([a-zA-Z\s])\1*/

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    Regex.scan(@reg, string)
    |> Enum.map_join( fn [run, c] ->
         times = String.length(run)

         number = 
           if times == 1 do 
             ""
           else
              times
           end
           "#{number}#{c}"

         end)
  end
  @dec_reg ~r/(\d*)(.)/
  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.scan(@dec_reg, string)
    |> Enum.map_join( fn [_,n, c] -> 
          times =
            if n == "" do 
              1
            else 
              String.to_integer(n)
            end

          String.duplicate(c, times)
        end)
  end
end
