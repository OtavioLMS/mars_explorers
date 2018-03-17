defmodule MarsExplorerTest do
  use ExUnit.Case
  doctest MarsExplorer

  test "runs correctly" do
    MarsExplorer.main("")

    assert File.read("test/io/output.txt")[1] ==
             {:ok,
              "1 3 N\n5 1 E\nthis probe was lost -> 0 -1\n4 1 E\nthis probe stopped because of an obstacle -> 6 1 "}
  end
end
