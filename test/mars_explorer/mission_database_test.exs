defmodule MarsExplorer.MissionDatabaseTest do
  use ExUnit.Case
  doctest MarsExplorer.MissionDatabase

  setup do
    {:ok, server_pid} =
      GenServer.start_link(
        MarsExplorer.MissionDatabase,
        %{x_boundary: 23, y_boundary: 34},
        name: MarsExplorer.MissionDatabase
      )

    {:ok, server: server_pid}
  end

  test "return the plateau" do
    assert GenServer.call(MarsExplorer.MissionDatabase, {:plateau_limits}) == %{
             x_boundary: 23,
             y_boundary: 34
           }
  end

  test "add more stanby probes and returns the current list of probes" do
    sample_probe = %{x_position: 2, y_position: 3, orientation: "N", healthy: true}
    initial_state = GenServer.call(MarsExplorer.MissionDatabase, {:probe_positions})
    assert initial_state == []
    GenServer.cast(MarsExplorer.MissionDatabase, [:add_probe, sample_probe])
    assert GenServer.call(MarsExplorer.MissionDatabase, {:probe_positions}) == [sample_probe]
  end

  test "check if a probe is already in the location" do
    sample_probe = %{x_position: 2, y_position: 3, orientation: "N", healthy: true}
    GenServer.cast(MarsExplorer.MissionDatabase, [:add_probe, sample_probe])
    assert GenServer.call(MarsExplorer.MissionDatabase, {:occupied, 2, 3})
  end

  test "remove the probe at the indicated position" do
    GenServer.cast(MarsExplorer.MissionDatabase, [:delete_probe, 2, 3])
    assert GenServer.call(MarsExplorer.MissionDatabase, {:occupied, 2, 3}) == false
  end
end
