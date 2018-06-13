defmodule Frequency do
  @doc """
  Count letter frequency in parallel.
  Returns a map of characters to frequencies.
  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}
  def frequency(texts, workers) do
    groups = Enum.map(0..(workers - 1), &stripe(&1, texts, workers))
             |> Enum.filter( fn string -> length(string) > 0 end)

    procs = Enum.map(groups,fn(_) ->
                   spawn(Frequency, :count_letter, [self()]) end)
    wait_ready(procs, :ready) 

    result = 
      send_group(groups, procs, [])
      |> wait_answer( %{})
    terminate(procs)

    result 
  end
  def send_group([], _, sendlist), do: sendlist 

  def send_group([mh | mt], [ph | pt], sendlist) do 
    sndproc =  
      Enum.map(mh, fn line ->
         send ph, {:count, line}
         ph
      end)
    sendlist = sendlist ++ sndproc
    send_group(mt, pt, sendlist)
  end
  def wait_answer([], map), do: map
  def wait_answer(sendlst, map) do
    {sendlst, ans} =
      receive do 
        {:resp, pid, map} -> {List.delete(sendlst, pid), map}
      end
    map = Map.merge(map, ans, fn _, a, b -> a + b end)
     
    wait_answer(sendlst, map)
  end
  def terminate(sendlst) do 
    lst = Enum.uniq(sendlst)
    Enum.each(lst, fn tsk -> send tsk, {:shutdown} end)
    #Process.sleep(1000)
  end
  def wait_ready({:error, _msg}, _), do: :error
  def wait_ready([],_), do: :allready
  def wait_ready(procs, :ready) do 
    procs =
      receive do 
        {:ready, proc} -> procs = List.delete(procs, proc)
      after
        500 -> 
          msg = "No all task ready yet in 500ms"
          IO.puts :stderr, "No all task ready yet in 500ms"
          {:error, msg} 
      end 
    wait_ready(procs, :ready)
  end
  def stripe(n, texts, workers) do 
    Enum.drop(texts, n) 
    #|> IO.inspect 
    |> Enum.take_every(workers)
  end

  def count_letter(pidd) do 
    send pidd, {:ready, self()}
    receive do 
      {:count, string} -> 
        #IO.inspect string
        map = count_text(string) 
        send pidd, {:resp, self(), map} 
      {:shutdown } ->
        #IO.inspect self() 
        exit(:normal)
    end
    count_letter(pidd)
  end
  @doc false
  def count_text(string) do 
    String.replace(string, ~r/\P{L}+/u, "")
    |> String.downcase()
    |> String.graphemes()
    #|> IO.inspect
    |> Enum.reduce( %{}, fn c, acc -> 
              Map.update(acc, c, 1, &(&1 + 1)) end)
  end
end
