defmodule MarsExplorer.ProbeTest do
  use ExUnit.Case
  doctest MarsExplorer.Probe

  test "turns left" do
    assert MarsExplorer.Probe.move(%{orientation: "N"}, "L") == %{orientation: "W"}
    assert MarsExplorer.Probe.move(%{orientation: "W"}, "L") == %{orientation: "S"}
    assert MarsExplorer.Probe.move(%{orientation: "S"}, "L") == %{orientation: "E"}
    assert MarsExplorer.Probe.move(%{orientation: "E"}, "L") == %{orientation: "N"}
  end

  test "turns right" do
    assert MarsExplorer.Probe.move(%{orientation: "N"}, "R") == %{orientation: "E"}
    assert MarsExplorer.Probe.move(%{orientation: "E"}, "R") == %{orientation: "S"}
    assert MarsExplorer.Probe.move(%{orientation: "S"}, "R") == %{orientation: "W"}
    assert MarsExplorer.Probe.move(%{orientation: "W"}, "R") == %{orientation: "N"}
  end

  test "steps into the correct directions" do
    assert MarsExplorer.Probe.move(%{orientation: "N", x_position: 3, y_position: 3}, "M") == %{
             orientation: "N",
             x_position: 3,
             y_position: 4
           }

    assert MarsExplorer.Probe.move(%{orientation: "E", x_position: 3, y_position: 3}, "M") == %{
             orientation: "E",
             x_position: 4,
             y_position: 3
           }

    assert MarsExplorer.Probe.move(%{orientation: "S", x_position: 3, y_position: 3}, "M") == %{
             orientation: "S",
             x_position: 3,
             y_position: 2
           }

    assert MarsExplorer.Probe.move(%{orientation: "W", x_position: 3, y_position: 3}, "M") == %{
             orientation: "W",
             x_position: 2,
             y_position: 3
           }
  end

  test "do nothing if unhealthy and ignore any other invalid parameters" do
    assert MarsExplorer.Probe.move(
             %{orientation: 2, y_position: "aa", x_position: 3, healthy: false},
             "jlfkerjlfejrMLMMRM"
           ) == %{orientation: 2, y_position: "aa", x_position: 3, healthy: false}
  end

  test "receives multiple commands" do
    assert MarsExplorer.Probe.move(%{orientation: "N", y_position: 3, x_position: 3}, "MLMMRM") ==
             %{orientation: "N", y_position: 5, x_position: 1}
  end
end
