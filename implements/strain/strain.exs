defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of 
  items where `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    Enum.filter(list, fn x -> fun.(x) end) 
    #do_keep(list, fun, []) 
  end
  def do_keep([], _, results), do: Enum.reverse(results)
  def do_keep([h | t], fun, results) do
    case apply(fun,[h]) do 
      true -> do_keep(t, fun, [h | results])
      _    -> do_keep(t, fun, results)
    end
  end
  @doc """
  Given a `list` of items and a function `fun`, return the list of 
  items where `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    Enum.filter(list, fn x -> fun.(x) != true end)
    #do_discard(list, fun, []) 
  end
  def do_discard([], _, results), do: Enum.reverse(results)

  def do_discard([h | t], fun, results) do 
    case apply(fun, [h]) do 
      true -> do_discard(t, fun, results)
      _    -> do_discard(t, fun, [h | results])
    end
  end
end
