defmodule MarsExplorer do
  alias MarsExplorer.MissionControl, as: MissionControl

  @moduledoc """
  Documentation for MarsExplorer.
  """

  def main(_args) do
    IO.puts(Application.get_env(:mars_explorer, :input_path))

    get_input(Application.get_env(:mars_explorer, :input_path))
    |> begin_mission
    |> mission_results
    |> Enum.join("\n")
    |> write_results(Application.get_env(:mars_explorer, :output_path))
  end

  defp get_input(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        String.split(content, "\n", trim: true)

      {:error, reason} ->
        raise reason
    end
  end

  defp begin_mission([plateau_data | probes_data]) do
    [plateau_x, plateau_y] = String.split(plateau_data, " ", trim: true)

    MissionControl.start_link(%{
      x_boundary: String.to_integer(plateau_x),
      y_boundary: String.to_integer(plateau_y)
    })

    lauch_probes(probes_data)
  end

  defp lauch_probes([probe_info, commands | rest]) do
    [probe_x, probe_y, orientation] = String.split(probe_info, " ", trim: true)

    [
      MissionControl.run_probe(
        String.to_integer(probe_x),
        String.to_integer(probe_y),
        orientation,
        commands
      )
      | lauch_probes(rest)
    ]
  end

  defp lauch_probes([]) do
    []
  end

  defp mission_results([%{healthy: true, x_position: x, y_position: y, orientation: o} | rest]) do
    ["#{x} #{y} #{o}" | mission_results(rest)]
  end

  defp mission_results([
         %{healthy: false, x_position: x, y_position: y, orientation: "UNKNOWN"} | rest
       ]) do
    ["this probe was lost -> #{x} #{y}" | mission_results(rest)]
  end

  defp mission_results([
         %{healthy: false, x_position: x, y_position: y, orientation: "PATH_BLOCKED"} | rest
       ]) do
    ["this probe stopped because of an obstacle -> #{x} #{y} " | mission_results(rest)]
  end

  defp mission_results([]) do
    []
  end

  defp write_results(result_string, file_path) do
    IO.puts(file_path)
    File.write!(file_path, result_string)
  end
end
