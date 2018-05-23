defmodule Grep do
  use Bitwise

  @line_num_flag    1  # print num
  @file_name        2  # print file name
  @case_insensitive 4  # don't care capital or small letters
  @invert           8  # to select non-matching line
  @entire_lines     16 # entire

  defp parse_flag("-n"), do: @line_num_flag
  defp parse_flag("-l"), do: @file_name
  defp parse_flag("-i"), do: @case_insensitive
  defp parse_flag("-v"), do: @invert
  defp parse_flag("-x"), do: @entire_lines

  defp parse_flags(flags) do
    flags
    |> Enum.map(&parse_flag/1)
    |> Enum.reduce(0, fn a, b -> a ||| b end)
  end
  def process_files(pattern, flags, files) do 
    
  end
  def matching_lines(pattern, flags, file) do 
    
    File.stream!(file)
    |> Enum.map(fn l -> String.trim_trailing(l, "\n") end)
    |> Enum.with_index(1)
    |> Enum.map(fn {l, i} -> {file, i, l} end)

    |> IO.inspect

  end 

  def is_match(pattern,  flags) do
    pat =
      if has_flag(flags, @entire_lines) do 
        "^#{pattern}$"
      else
        pattern
      end
    cas = 
      if has_flag(flags, @case_insensitive) do 
        "i"
      else
        ""
      end
    regex = Regex.compile!(pat,cas)

    fn line -> Regex.match?(regex, line) != has_flag(flags, @invert) end
  end

  @doc """
    
  -i  Perform pattern matching in searches without regard to case
  -l  Write only the names of files containing selected lines to standard
      output. Pathnames shall be written once per file searched. 
  -n  Precede each output line by its relative line numer in the file,
      each file starting at line 1. The line number counter shall be
      reset for each file processed.
  -v  Select lines not matching any of the specified patterns. If the -v
      option is not specified, selected lines shall be those that match
      any of the specified patterns.
  -x  Consider only input lines that use all characters in the line
      excluding the terminating <newline> to match an entire fixed
      string or reqular expression to be matching lines.


  """
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flag_args, files) do
    flags = parse_flags(flag_args)

    output = 
      if has_flag(flags, @file_name) do 
        process_files(pattern, flags, files)
      else
        process_lines(pattern, flags, files)
      end

    output
    |> Enum.map(fn l -> "#{l}\n" end)
    |> Enum.reduce("", fn b, a -> "#{a}#{b}" end)
  end
end
