defmodule GetStream.Modules.User do
  @moduledoc """
    Manage GetStream Users
  """

  defstruct [
    :id,
    :role,
    :banned,
    :ban_expires,
    :invisible,
    :push_notifications,
    :language,
    :teams,
    :additional_info
  ]

  def create_guest(_params) do
    {:ok, %__MODULE__{}}
  end

  def upsert_user(_params) do
    {:ok, %__MODULE__{}}
  end

  def ban_user(_params) do
    {:ok, %__MODULE__{}}
  end
end
