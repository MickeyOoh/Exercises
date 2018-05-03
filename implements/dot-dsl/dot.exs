defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  @doc """
   ast: Abstract Syntax Tree

  """
  defmacro exprt(ast) do 
    escaped = Macro.escape(ast)
    #IO.inspect escaped
    quote do 
      Code.eval_quoted(unquote(escaped), [], __ENV__) |> elem(0)
    end
  end
  #defmacro graph(ast) do
  defmacro graph(do: ast) do
    g = do_graph(ast)
 
    Macro.escape(%Graph{
      attrs: Enum.sort(g.attrs),
      nodes: Enum.sort(g.nodes),
      edges: Enum.sort(g.edges)
    })
  end
  def do_graph(nil) do 
    %Graph{}
  end
  def do_graph({:__block__, _, stmts}) do 
    ##IO.puts "do_graph({:__block__,**)-> stmts:#{inspect stmts}"
    # Enum.reduce(enumerable, acc, fun)
    #       (t(), any(), (element(), any() -> any())) :: any()
    Enum.reduce(stmts, %Graph{}, &do_stmt/2) 
  end
  def do_graph(stmt) do 
    ##IO.puts "do_graph(stmt)->#{inspect stmt}"
    do_stmt(stmt, %Graph{})
  end

  @doc """
  do_stmt -> make statement 
  """
  # :graph function  -> into attrs:
  def do_stmt(stmt = {:graph, _, [kws]}, g) when is_list(kws) do 
    ##IO.puts "do_stmt->#{inspect kws}"
    if Keyword.keyword?(kws) do 
      %{g | attrs: kws ++ g.attrs}
    else
      raise_invalid_stmt(stmt)
    end 
  end
  # the other atom, then we put data into nodes:
  def do_stmt({atom, _, nil}, g) 
  when is_atom(atom) and atom != :-- do
    ##IO.puts "do_stmt({atom,..)->#{inspect atom}"
    %{g | nodes: [{atom, []} | g.nodes]}
  end
  # atom and list exist, we put data into nodes: 
  def do_stmt(stmt = {atom,_, [kws]}, g)
  when is_atom(atom) and atom != :-- and is_list(kws) do 
    if Keyword.keyword?(kws) do 
      %{g | nodes: [{atom, kws} | g.nodes]}
    else
      raise_invalid_stmt(stmt)
    end
  end
  # :-- then we put data into edges: 
  def do_stmt({:--, _, [{a, _, nil}, {b, _, nil}]}, g)
  when is_atom(a) and is_atom(b) do 
    %{g | edges: [{a, b, []} | g.edges]}
  end
  # :-- then we put data into edges: 
  def do_stmt(stmt = {:--, _, [{a, _, nil}, {b, _, [kws]}]}, g)
  when is_atom(a) and is_atom(b) and is_list(kws) do
    if Keyword.keyword?(kws) do
      %{g | edges: [{a, b, kws} | g.edges]}
    else
      raise_invalid_stmt(stmt)
    end
  end
  # in the other case, invalid error happens 
  def do_stmt(stmt, _) do
    raise_invalid_stmt(stmt)
  end
  defp raise_invalid_stmt(stmt) do 
    raise ArgumentError, message: "Invalid statement: #{inspect stmt}"
  end

  def test1 do 
    ans = exprt(
            Dot.graph do 
            end
          )
    IO.puts "test1->#{inspect ans}"
  end

end
