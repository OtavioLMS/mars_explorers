defmodule MarsExplorer.MissionControl do
  alias MarsExplorer.ProbeStatus, as: ProbeStatus
  alias MarsExplorer.Probe, as: Probe

  @moduledoc """
  the mission control module is a central hub of the project meant to 
  intermediate communication between other modules
  """

  @doc """
  starts the connection with MissionDatabse GenServer
  MUST BE RUN BEFORE ANY OTHER FUNCTION

  receives the information about the plateau as a parameter
  """
  def start_link(plateau) do
    GenServer.start_link(
      MarsExplorer.MissionDatabase,
      plateau,
      name: MarsExplorer.MissionDatabase
    )
  end

  @doc """
  starts executing the probe and, if nothing fails, saves its final position on
  the MissionDatabase Server

  receives 4 parameters
  x is the probe's initial x coodinate
  y is the probe's initial y coodinate
  orientation is the direction the probe's front is ponted(in "N", "S", "E", "W")
  commands are the commands sent from earth to the probe as a string
  """
  def run_probe(x, y, orientation, commands) do
    probe_final_status = ProbeStatus.new(x, y, orientation) |> Probe.move(commands)
    GenServer.cast(MarsExplorer.MissionDatabase, [:add_probe, probe_final_status])
    probe_final_status
  end

  @doc """
  gets the plateau limit coordinates from the MissionDatabase
  and compares with the probe's estimated position to see if it fell out of the
  area of operations, if it did fall the code changes the healthy flag to false
  and saves the estimated position on the database

  receives the expected next position of the probe
  """
  def health_check(%{x_position: x, y_position: y} = probe_data) do
    plateau = GenServer.call(MarsExplorer.MissionDatabase, {:plateau_limits})
    position_occupied = GenServer.call(MarsExplorer.MissionDatabase, {:occupied, x, y})

    cond do
      x < 0 || y < 0 || x > plateau.x_boundary || y > plateau.y_boundary ->
        new_probe_status = %{probe_data | orientation: "UNKNOWN", healthy: false}
        new_probe_status

      position_occupied ->
        new_probe_status = %{probe_data | orientation: "UNKNOWN", healthy: false}
        GenServer.cast(MarsExplorer.MissionDatabase, [:delete_probe, x, y])
        GenServer.cast(MarsExplorer.MissionDatabase, [:add_probe, new_probe_status])
        new_probe_status

      true ->
        probe_data
    end
  end
end
