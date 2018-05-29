defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], acc), do: acc
  defp do_count([_ | t], acc), do: do_count(t, acc + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])
  defp do_reverse([], acc), do: acc
  defp do_reverse([h | t], acc) do 
    #acc = [h] ++ acc
    do_reverse(t, [h | acc]) 
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])
  defp do_map([], _f, acc), do: acc
  defp do_map([h | t], f, acc) do
    acc = acc ++ [f.(h)]
    do_map(t, f, acc)
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])
  defp do_filter([], _f, acc), do: acc
  defp do_filter([h | t], f, acc) do
    acc = if f.(h), do: acc ++ [h], else: acc
    do_filter(t, f, acc)
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f), do: do_reduce(l, acc, f)
  defp do_reduce([], acc, _f), do: acc
  defp do_reduce([h | t], acc, f) do
    acc = f.(h, acc)
    do_reduce(t, acc, f)
  end

  @spec append(list, list) :: list
  def append(a, b), do: do_append(a, b) 
  defp do_append(a, []), do: a
  defp do_append(a, [h | t]) do
    a = a ++ [h]
    do_append(a, t)  
  end
  @spec concat([[any]]) :: [any]
  def concat(ll), do: reverse(ll) |> reduce([], &append(&1, &2))

end
