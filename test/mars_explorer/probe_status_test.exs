defmodule MarsExplorer.ProbeStatusTest do
  use ExUnit.Case
  doctest MarsExplorer.ProbeStatus

  test "function new generate a probe status struct with the data passed" do
    assert MarsExplorer.ProbeStatus.new(2, 3, "N") == %MarsExplorer.ProbeStatus{
             x_position: 2,
             y_position: 3,
             orientation: "N",
             healthy: true
           }
  end
end
