defmodule MarsExplorer.ProbeStatus do
  @moduledoc """
  module containing the struct that represents the position and orientation of
  a mars exploration probe
  """
  @enforce_keys [:x_position, :y_position, :orientation]
  defstruct [:x_position, :y_position, :orientation, :healthy]

  @doc """
  creates a ProbeStatus struct with passed arguments
  receives 3 parameters
  x coordinate
  y coordinate
  orientation(the direction the probe's front is pointing)
  """
  def new(x, y, orientation) do
    %MarsExplorer.ProbeStatus{
      x_position: x,
      y_position: y,
      orientation: orientation,
      healthy: true
    }
  end
end
