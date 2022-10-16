defmodule GetStream.Modules.ChannelTypes do
  @moduledoc """
    Manage Channel Type
  """

  defstruct [:id]

  def create(_params) do
    {:ok, %__MODULE__{}}
  end

  def delete(_params) do
    {:ok, %__MODULE__{}}
  end

  def get(_channel_type_name) do
    {:ok, %__MODULE__{}}
  end

  def list() do
    {:ok, [%__MODULE__{}]}
  end

  def update(_params) do
    {:ok, %__MODULE__{}}
  end
end
