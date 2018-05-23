defmodule Grep.CLI do 
  @moduledoc """
  """
  import Grep.Search
  #  import Grep.TableFormatter, only: [ print_table_for_columns: 2] 

  #def run(argv) do 
  def main(argv) do 
    argv
    |> parse_args
    |> process
    |> printout
  end

  def process(:help) do 
    IO.puts """
    Usage: grep <opts> <pattern> <files> 
         opts : -n line numbers
                -l file name 
                -x invert
                -i don't care case 
    """
    System.halt(0)
  end
  def process({:lines, fnregex, files, outfmt}) do
    process_lines(fnregex, files, outfmt) 
  end
  def process({:files, fnregex, files, outfmt}) do
    process_files(fnregex, files, outfmt) 
  end

  defp printout(outlst) do
    outlst 
    # set return code into the end of each list
    |> Enum.map(fn l -> "#{l}\n" end)
    # link all list char
    |> Enum.reduce("", fn b, a -> "#{a}#{b}" end)
    # print out
    |> IO.puts
  end
end

