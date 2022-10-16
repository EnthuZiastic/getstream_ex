defmodule GetStream.Modules.Channel do
  @moduledoc """
    Manage Channel
  """

  defstruct [:id]

  def create_channel_with_type(_channel_type, _channel_id, _params) do
    {:ok, %__MODULE__{}}
  end

  def update_channel(_channel_type, _channel_id, _options) do
    {:ok, %__MODULE__{}}
  end

  def delete_channel(_channel_type, _channel_id) do
    {:ok, %__MODULE__{}}
  end

  def add_members(_channel_type, _channel_id, _members) do
    {:ok, %__MODULE__{}}
  end

  def remove_memebers(_channel_type, _channel_id, _members) do
    {:ok, %__MODULE__{}}
  end

  def add_moderators(_channel_type, _channel_id, _mods) do
    {:ok, %__MODULE__{}}
  end

  def remove_moderators(_channel_type, _channel_id, _mods) do
    {:ok, %__MODULE__{}}
  end
end
