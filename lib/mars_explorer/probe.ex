defmodule MarsExplorer.Probe do
  alias MarsExplorer.MissionControl, as: MissionControl

  @moduledoc """
  probe module represents the probe receiving commands
  """

  @doc """
  receives the information of the current probe as a map or a struct and a string of commands
  returns the updated position information of the probe
  returns original state if the command string is empty
  accepted command chars on the string are "L", "R" and "M"
  "L" -> turns probe left
  "R" -> turns probe right
  "M" -> moves probe forward

  ## Examples

      iex> MarsExplorer.Probe.move(%{orientation: "N", y_position: 2, x_position: 4}, "MMLMMRM")
      %{orientation: "N", x_position: 2, y_position: 5}

  """

  def move(%{healthy: false} = current_probe_status, _) do
    current_probe_status
  end

  def move(current_probe_status, "L" <> command_queue) do
    change_orientation(current_probe_status, :plus) |> move(command_queue)
  end

  def move(current_probe_status, "R" <> command_queue) do
    change_orientation(current_probe_status, :minus) |> move(command_queue)
  end

  def move(current_probe_status, "M" <> command_queue) do
    step(current_probe_status) |> move(command_queue)
  end

  def move(current_probe_status, "") do
    current_probe_status
  end

  defp change_orientation(current_probe_status, :plus) do
    %{"N" => "W", "W" => "S", "S" => "E", "E" => "N"}[current_probe_status.orientation]
    |> set_new_orientation(current_probe_status)
  end

  defp change_orientation(current_probe_status, :minus) do
    %{"N" => "E", "E" => "S", "S" => "W", "W" => "N"}[current_probe_status.orientation]
    |> set_new_orientation(current_probe_status)
  end

  defp set_new_orientation(orientation, current_probe_status) do
    %{current_probe_status | orientation: orientation}
  end

  defp step(current_probe_status) do
    new_probe_status =
      case current_probe_status.orientation do
        "N" -> %{current_probe_status | y_position: current_probe_status.y_position + 1}
        "S" -> %{current_probe_status | y_position: current_probe_status.y_position - 1}
        "E" -> %{current_probe_status | x_position: current_probe_status.x_position + 1}
        "W" -> %{current_probe_status | x_position: current_probe_status.x_position - 1}
      end

    MissionControl.health_check(new_probe_status, current_probe_status)
  end
end
