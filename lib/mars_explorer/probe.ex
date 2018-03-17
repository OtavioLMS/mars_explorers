defmodule MarsExplorer.Probe do
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
  def move(current_probe, "L" <> command_queue) do
    change_orientation(current_probe, :plus) |> move(command_queue)
  end

  def move(current_probe, "R" <> command_queue) do
    change_orientation(current_probe, :minus) |> move(command_queue)
  end

  def move(current_probe, "M" <> command_queue) do
    step(current_probe) |> move(command_queue)
  end

  def move(current_probe, "") do
    current_probe
  end

  defp change_orientation(current_probe, :plus) do
    %{"N" => "W", "W" => "S", "S" => "E", "E" => "N"}[current_probe.orientation] 
    |> set_new_orientation(current_probe)
  end

  defp change_orientation(current_probe, :minus) do
    %{"N" => "E", "E" => "S", "S" => "W", "W" => "N"}[current_probe.orientation] 
    |> set_new_orientation(current_probe)
  end

  defp set_new_orientation(orientation, current_probe) do
    %{current_probe | orientation: orientation}
  end

  defp step(current_probe) do
    case current_probe.orientation do
      "N" -> %{current_probe | y_position: current_probe.y_position + 1}
      "S" -> %{current_probe | y_position: current_probe.y_position - 1}
      "E" -> %{current_probe | x_position: current_probe.x_position + 1}
      "W" -> %{current_probe | x_position: current_probe.x_position - 1}
    end
  end
end