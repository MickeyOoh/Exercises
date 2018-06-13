defmodule Fib do 
  def fib(scheduler) do
    IO.puts "started fib task #{inspect self()}" 
    send scheduler, { :ready, self() }
    receive do 
      { :fib, n, client } ->
        IO.puts "receive #{n} from #{inspect client}"
        send client, { :anser, n, fib_calc(n), self() }
        IO.puts "send-><#{inspect client}> n:#{n} from #{inspect self()}"
        fib(scheduler)
      { :shutdown } -> 
          exit(:normal)
    end
  end

  # very inefficient, deliberately
  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n-1) + fib_calc(n-2)
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
        IO.puts ":ready(#{inspect pid}) len:#{length(queue)}"
        send pid, {:fib, next, self()}
        schedule_processes(processes, tail, results)
      {:ready, pid} -> 
        IO.puts ":ready(#{inspect pid } -> :shutdown"
        send pid, {:shutdown}
        if length(processes) > 1 do 
          schedule_processes(List.delete(processes, pid),queue,results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        IO.puts ":answer->#{number} result->#{result}"
        schedule_processes(processes, queue,
                           [{number, result} | results])
    end
  end
end

to_process = [37, 37, 37, 37, 37, 37]

Enum.each 1..10, fn num_processes ->
  {time, result} = :timer.tc(
    Scheduler, :run, 
    [num_processes,Fib,:fib,to_process]
  )
  if num_processes == 1 do 
    IO.inspect result
    IO.puts "\n #   time (s)"
  end
  :io.format "~2B     ~.2f~n", [num_processes, time/1000000.0]
end

