defmodule ParallelTest do
  use ExUnit.Case
  doctest Parallel

  test "greets the world" do
    assert Parallel.hello() == :world
  end
end
