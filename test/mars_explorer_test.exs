defmodule MarsExplorerTest do
  use ExUnit.Case
  doctest MarsExplorer

  test "greets the world" do
    assert MarsExplorer.hello() == :world
  end
end
