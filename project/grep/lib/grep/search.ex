defmodule Grep.Search do
  @moduledoc """
  Documentation for Grep.
  """
  @switch [help: :boolean, line_num: :boolean, file_name: :boolean,
           case: :boolean, invert: :boolean, entire: :boolean] 
  @alias [n: :line_num,l: :file_name,i: :case,
          v: :invert,  x: :entire,   h: :help]

  def parse_args(argv) do 
    # parse(argv(), options()) :: {parsed(), argv(), errors()}
    parses = OptionParser.parse(argv, switches: @switch, aliases: @alias)
    case parses do
    {:help, _, _} -> :help
    { opts, [pattern | files], _} -> 
      # search chars -> regex -> function 
      fnregex = mk_regex(opts, pattern)
      # single file? , print_number?
      outfmt = line_formatter(length(files) == 1, opts[:line_num] != nil) 
      #IO.puts "regex(#{inspect regex}),outfmt->#{inspect outfmt}"
      if opts[:file_name] == true do
        { :files, fnregex, files, outfmt}
      else
        { :lines, fnregex, files, outfmt}
      end
     _ -> :help
    end
  end
  defp mk_regex(opts, pattern) do 
    pat = if opts[:entire], do: "^#{pattern}$",else: pattern
    cas = if opts[:case], do: "i", else: ""
                  
    regex = Regex.compile!(pat, cas)
    #|> IO.inspect
    invert = Keyword.get_values(opts, :entire) != []
    fn line -> Regex.match?(regex, line) != invert end
  end

  defp line_formatter(single_file?, print_nums?) do 
    # f: file name, ix:line num, l: chars of line 
    fn {f, ix, l} ->
      case {single_file?, print_nums?} do 
        {true,  true} -> "#{ix}:#{l}"
        {false, true} -> "#{f}:#{ix}:#{l}"
        {true, false} -> "#{l}"
        {false,false} -> "#{f}:#{l}"
      end
    end
  end
  
  defp matching_lines(fnregex, file) do
    File.stream!(file)
    |> Enum.map(fn l -> String.trim_trailing(l, "\n") end)
    |> Enum.with_index(1)
    |> Enum.map(fn {l, i} -> {file, i, l} end)
    |> Enum.filter(fn {_, _, l} -> fnregex.(l) end)
  end

  def process_files(fnregex, files, _) do
    files
    |> Enum.filter(fn x -> 
            !Enum.empty?(matching_lines(fnregex, x)) end)
  end

  def process_lines(fnregex, files, outfmt) do
    files
    |> Enum.flat_map(fn x -> matching_lines(fnregex, x) end)
    |> Enum.map(outfmt)
  end
end

