defmodule MarsExplorer.MissionDatabase do
  use GenServer

  @moduledoc """
  the mission databse is the state keeper module of the application
  it's a genserver with server behaviour only it keeps the sie of the plateau
  and the list of probes that finished the mission and are on standby
  """

  @doc """
  when the client starts the link with this genserver
  the server initialises with an empty list of probes and the boundaries of the plateau

  receives the plateau's boundaries as parameter
  """
  def init(plateau) do
    {:ok, %{standby_probes: [], plateau: plateau}}
  end

  @doc """
  handles the synchronous call to respond with the plateu's boundaries
  without changing states
  """
  def handle_call({:plateau_limits}, _from, current_state) do
    {:reply, current_state.plateau, current_state}
  end

  @doc """
  handles the synchronous call to respond with the information
  of the standby probes
  """
  def handle_call({:probe_positions}, _from, current_state) do
    {:reply, current_state.standby_probes, current_state}
  end

  def handle_call({:occupied, x, y}, _from, current_state) do
    {
      :reply,
      Enum.any?(current_state.standby_probes, fn probe ->
        probe.x_position == x && probe.y_position == y
      end),
      current_state
    }
  end

  @doc """
    handles the ynchronous call to save the last position of the probe
    when it ends the commands it received or the predicted position of a lost probe
  """
  def handle_cast([:add_probe, probe], current_state) do
    {:noreply, %{current_state | standby_probes: [probe | current_state.standby_probes]}}
  end

  def handle_cast([:delete_probe, x, y], current_state) do
    {
      :noreply,
      %{
        current_state
        | standby_probes:
            Enum.reject(current_state.standby_probes, fn probe ->
              probe.x_position == x && probe.y_position == y
            end)
      }
    }
  end
end
