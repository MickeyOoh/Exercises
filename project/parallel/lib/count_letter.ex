defmodule Count_letter do 
  def count(pid, string) do
    #IO.puts "started fib task #{inspect self()}" 
    send scheduler, { :ready, self() }
    receive do 
      { :start n, client } ->
        send client, { :anser, n, fib_calc(n), self() }
        IO.puts "send client<#{inspect client}> n=#{n} from #{inspect self()}"
        count(scheduler)
      { :shutdown } -> 
          exit(:normal)
    end
  end
  def count_text(string) do 
    String.replace()
    |> String.downcase()
    |> String.graphemes()
    |> Enum.reduce( %{}, fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end
  def freq(texts, workers) do 
    groups = Enum.map(0..(workers - 1), &stripe(&1, texts, workers))
    groups = Enum.filter(groups, fn string -> length(string) == 0 end) 
    procs  = Enum.map(groups, 
                fn(s) -> spawn(Count_letter, :process, [self()]) end)

    Enum.map(groups,
              fn(strings) -> 
                send spawn(Count_letter, count, [self()]) end)

     
  end
  defp merge_freqs(map) do 
    Enum.reduce(map, %{}, 
        fn d, acc -> Map.merge(acc, d, fn _, a, b -> a + b end)
      end)
  end
end

defmodule Scheduler do 
  @doc """
  spawn number of moudle:func processes
  """
  def run(num_processes, module, func, to_calculate) do 
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do 
    receive do 
      {:ready, pid} when length(queue) > 0 -> 
        [ next | tail ] = queue
        send pid, {:fib, next, self()}
        schedule_processes(processes, tail, results)
      {:ready, pid} -> 
        send pid, {:shutdown}
        if length(processes) > 1 do 
          schedule_processes(List.delete(processes, pid),queue,results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue,
                           [{number, result} | results])
    end
  end
end

#to_process = [37, 37, 37, 37, 37, 37]

#Enum.each 1..10, fn num_processes ->
#  {time, result} = :timer.tc(
#    Scheduler, :run, 
#    [num_processes,Count_letter,:count,to_process]
#  )
#  if num_processes == 1 do 
#    IO.inspect result
#    IO.puts "\n #   time (s)"
#  end
#  :io.format "~2B     ~.2f~n", [num_processes, time/1000000.0]
#end

