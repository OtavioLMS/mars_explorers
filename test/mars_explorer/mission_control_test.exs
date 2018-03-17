defmodule MarsExplorer.MissionControlTest do
  use ExUnit.Case
  doctest MarsExplorer.MissionControl

  test "start link with database genserver" do
    assert MarsExplorer.MissionControl.start_link(%{x_boundary: 23, y_boundary: 34})
  end

  test "run probe to the end" do
    MarsExplorer.MissionControl.start_link(%{x_boundary: 23, y_boundary: 34})

    assert MarsExplorer.MissionControl.run_probe(9, 8, "N", "LMRMM") == %MarsExplorer.ProbeStatus{
             healthy: true,
             orientation: "N",
             x_position: 8,
             y_position: 10
           }
  end

  test "return unhealthy probe when out of bounds" do
    MarsExplorer.MissionControl.start_link(%{x_boundary: 23, y_boundary: 34})

    assert MarsExplorer.MissionControl.health_check(%MarsExplorer.ProbeStatus{
             healthy: true,
             orientation: "N",
             x_position: -1,
             y_position: 10
           }) == %MarsExplorer.ProbeStatus{
             healthy: false,
             orientation: "UNKNOWN",
             x_position: -1,
             y_position: 10
           }
  end

  test "return unhealthy probe when hits another probe" do
    MarsExplorer.MissionControl.start_link(%{x_boundary: 23, y_boundary: 34})
    MarsExplorer.MissionControl.run_probe(8, 9, "N", "")

    assert MarsExplorer.MissionControl.health_check(%MarsExplorer.ProbeStatus{
             healthy: true,
             orientation: "S",
             x_position: 8,
             y_position: 9
           }) == %MarsExplorer.ProbeStatus{
             healthy: false,
             orientation: "UNKNOWN",
             x_position: 8,
             y_position: 9
           }
  end

  test "return original probe when all is ok" do
    test_probe = %MarsExplorer.ProbeStatus{
      healthy: true,
      orientation: "S",
      x_position: 8,
      y_position: 9
    }

    MarsExplorer.MissionControl.start_link(%{x_boundary: 23, y_boundary: 34})
    assert MarsExplorer.MissionControl.health_check(test_probe) == test_probe
  end
end
