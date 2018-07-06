defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, 
                      left: BinTree.t() | nil, 
                      right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error 
  # messages much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes
  # (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule BinTree.Zipper do 
  @moduledoc """
  A binary tree zipper

  'value is the value of the focus.


  """
  @type t :: %BinTree.Zipper{
          value: any,
          left:  BinTree.Zipper.t() | nil,
          right: BinTree.Zipper.t() | nil,
          trail: [{:left, any, BinTree.t()} |
                  {:right, any, BinTree.t()}]
        }
  defstruct value: nil, left: nil, right: nil, trail: []
end

defmodule Zipper do
  alias BinTree, as: BT
  alias BinTree.Zipper, as: Z

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(%BT{value: v, left: l, right: r}) do
    %Z{value: v, left: l, right: r, trail: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(%Z{value: v, left: l, right: r, trail: t}) do
    do_to_tree(%BT{value: v, left: l, right: r}, t)
  end
  def do_to_tree(b, []) do 
    b
  end
  def do_to_tree(b, [{:left, pv, pr} | pt]) do 
    do_to_tree(%BT{value: pv, left: b, right: pr}, pt)
  end
  def do_to_tree(b, [{:right, pv, pl} | pt]) do 
    do_to_tree(%BT{value: pv, left: pl, right: b}, pt)
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(%Z{value: v}), do: v

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(%Z{left: nil}), do: nil
  
  def left(%Z{value: v,
              left:  %BT{value: lv, left: ll, right: lr},
              right: r,
              trail: zt}) do
    %Z{value: lv, left: ll, right: lr, trail: [{:left, v, r} | zt]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(%Z{ right: nil}), do: nil
  def right(%Z{ value: v, 
                left: l,
                right: %BT{value: rv,left:  rl, right: rr},
                trail: zt}) do 
    %Z{value: rv, left: rl, right: rr, trail: [{:right, v, l} | zt]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Z{value: v, left: l, right: r, trail: t}) do
    case t do
      [] -> nil
      [{:left, pv, pr} | zt] ->
        %Z{value: pv, 
          left: %BT{value: v, left: l, right: r}, 
          right: pr, 
          trail: zt}

      [{:right, pv, pl} | zt] ->
        %Z{value: pv,
          left: pl,
          right: %BT{value: v, left: l, right: r},
          trail: zt}
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(z, v), do: %{z | value: v}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(z, l), do: %{z | left: l}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right(z, r), do: %{z | right: r}

  # testing tool
  #def bt(value,left,right), do: %BT{value: value,left: left,right: right}
  #def leaf(value), do: %BT{value: value}
  #def t1, do: bt(1, bt(2, nil, leaf(3)), leaf(4))
  #def t2, do: bt(1, bt(5, nil, leaf(3)), leaf(4))
  #def t3, do: bt(1, bt(2, leaf(5), leaf(3)), leaf(4))
  #def t4, do: bt(1, leaf(2), leaf(4))
  #def t5, do: bt(1, bt(2, nil, leaf(3)), bt(6, leaf(7), leaf(8)))
  #def t6, do: bt(1, bt(2, nil, leaf(5)), leaf(4))
end
