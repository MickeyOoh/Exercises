defmodule BinarySearchTree do
  @type bst_node :: %{data: any,
                      left: bst_node | nil, 
                      right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: new(data)
  def insert(tree, set_data) do
    %{data: data, left: left, right: right} = tree
    if set_data <= data do 
      %{data: data,left: insert(left,set_data),right: right}
    else
      %{data: data,left: left,right: insert(right,set_data)}
    end 
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do 
    in_order(tree, []) 
    #|> IO.inspect
  end
  def in_order(nil, lst) do 
    lst
  end
  def in_order(tree, lst) do
    #%{data: data, left: left, right: right} = tree
    #if left != nil do
    #  in_order(left, lst )
    #else 
    #  lst = lst ++ [data]
    #  IO.inspect lst
    #  if right != nil do
    #    in_order(right, lst)
    #  end
    #end
    left_side = in_order(tree.left, lst)
    #IO.puts "data:#{tree.data} | left:#{inspect left_side}"
    #middle = [tree.data | left_side]
    middle = left_side ++ [tree.data]
    in_order(tree.right, middle) 
  end 
end
