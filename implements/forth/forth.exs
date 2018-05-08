defmodule Forth do
  defmodule State do 
    @type t :: %__MODULE__{}

    defstruct stack: [], defs: %{}, input: []
  end

  @opaque evaluator :: State.t()

  defmodule Primitives do 
    def defs do 
      %{
        "+"    => &math_op(&1, :+),
        "-"    => &math_op(&1, :-),
        "*"    => &math_op(&1, :*),
        "/"    => &math_op(&1, :/),
        "DUP"  => &dup/1,
        "DROP" => &drop/1,
        "SWAP" => &swap/1,
        "OVER" => &over/1
      }
    end

    def math_op(s, op) do 
      {s, [a, b]} = pop(s, 2)
      
      res = 
        case op do 
          :+ -> a + b
          :- -> a - b
          :* -> a * b
          :/ when b == 0 -> raise Forth.DivisionByZero
          :/ -> div(a, b)
        end
      IO.puts "#{a} #{Atom.to_string(op)} #{b} -> #{res} -> stack"
      push(s, res)
    end
    defp dup(s) do 
      {s, [x]} = pop(s, 1)
      %{s | stack: [x, x | s.stack]}
    end
    defp drop(s) do 
      {s, _} = pop(s, 1)
      s
    end
    defp swap(s) do 
      {s, [a, b]} = pop(s, 2)
      %{s | stack: [a, b | s.stack]}
    end
    defp over(s) do 
      case s.stack do 
        [b, a | t] -> %{s | stack: [a, b, a | t]}
        _          -> raise Forth.StackUnderflow
      end
    end

    def pop(s, n) do 
      {stack, acc} = do_pop(s.stack, n, [])
      {%{s | stack: stack}, acc}
    end
    def do_pop(stack, 0, acc) do
      {stack, acc}
    end
    def do_pop([h | t], n, acc) do 
      do_pop(t, n - 1, [h | acc])
    end
    def do_pop([], _, _) do
      raise(Forth.StackUnderflow)
    end
    def push(s, x) do
      #IO.puts "s(#{inspect s}),x(#{inspect x}),s.stack(#{inspect s.stack})"
      %{s | stack: [x | s.stack]}
    end
  end
  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %State{defs: Primitives.defs()}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    str = tokenize(s)
    IO.puts "(#{inspect str})"
    #do_eval(%{ev | input: ev.input ++ tokenize(s)})
    do_eval(%{ev | input: ev.input ++ str})
  end

  defp do_eval(s = %State{input: []}) do
    IO.puts "1.%State{input: []} -> stack: #{inspect s.stack}"
    s
  end

  # puts h into stack <- is_integer(h) number 
  defp do_eval(s = %State{stack: stack, input: [h | t]})
  when is_integer(h) do 
    IO.puts "2.%State{stack: #{inspect stack},input: [#{h} | t]}"
    do_eval(%{s | stack: [h | stack], input: t})
  end
  defp do_eval(s = %State{input: [":", h | t]}) do 
    IO.puts "3.%State{input: [\":\", #{h} | t]}"
    if is_binary(h) do 
      w = String.upcase(h)

      case Enum.split_while(t, &(&1 != ";")) do 
        # ";" not found
        {_, []} ->
          s
        {ws, [";" | r]} ->
          do_eval(%{s | defs: Map.put(s.defs, w, ws), input: r})
      end
    else
      # User tried to define a number
      raise Forth.InvalidWord, word: h
    end
  end
  # + - * / <- is_binary(h) means symbol
  defp do_eval(s = %State{defs: defs, input: [h | t]}) 
  when is_binary(h) do
    IO.puts "4.%State{defs: defs,input: [ #{h} | t]} <- stack: #{inspect s.stack}"
    w = String.upcase(h)
    #IO.puts "defs[#{w}]->#{inspect defs[w]}" 
    case defs[w] do
      nil ->
        raise Forth.UnknownWord, word: w
      d when is_function(d) ->
        do_eval(d.(%{s | input: t}))
      d when is_list(d) ->
        do_eval(%{s | input: d ++ t})
    end
  end
  def tokenize(s) do
    #IO.inspect s
    Regex.scan(~r/[\p{L}\p{N}\p{S}\p{P}]+/u, s)
    #|> IO.inspect
    |> Stream.map(&hd/1)
    |> Enum.map(fn t ->
         case Integer.parse(t) do 
           {i, ""} -> i
           _       -> t
         end
       end)
   end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  #def format_stack(ev) do
  def format_stack(%State{stack: stack}) do
    Enum.reverse(stack) |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end
  
  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end

  @rex ~r/[\p{L}\p{N}\p{S}\p{P}]+/u 
  @sts  "1\x002\x013\n4\r5 6\t7"
  @sts2 "1\x002\x013\n4\r5-6\t7"
  def test1 do 
    IO.inspect @sts 
    IO.inspect @sts2 
    Regex.scan(@rex, @sts) |> IO.inspect
    s = new() |> eval(@sts) |> format_stack()
    IO.puts s 
  end
end
