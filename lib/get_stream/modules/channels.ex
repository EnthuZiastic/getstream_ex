defmodule GetStream.Modules.Channel do
  @moduledoc """
    Manage Channel
  """

  alias GetStream.Request
  alias GetStream.Utils

  defstruct [
    :cid,
    :config,
    :created_at,
    :created_by,
    :disabled,
    :frozen,
    :hidden,
    :id,
    :own_capabilities,
    :members,
    :messages,
    :pinned_messages,
    :type
  ]

  def create_channel_with_type(channel_type, channel_id, params) do
    params = Utils.put_created_by_in_data(params)

    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}/query")
    |> Request.with_token()
    |> Request.with_method(:post)
    |> Request.with_body(params)
    |> Request.send()
    |> parse_resp()
  end

  def update_channel(channel_type, channel_id, options) do
    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}")
    |> Request.with_token()
    |> Request.with_method(:post)
    |> Request.with_body(options)
    |> Request.send()
    |> parse_resp()
  end

  def delete_channel(channel_type, channel_id) do
    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}")
    |> Request.with_token()
    |> Request.with_method(:delete)
    |> Request.send()
    |> parse_resp()
  end

  def add_members(channel_type, channel_id, members) do
    update_channel(channel_type, channel_id, %{"add_members" => members})
  end

  def remove_memebers(channel_type, channel_id, member_ids) do
    update_channel(channel_type, channel_id, %{"remove_members" => member_ids})
  end

  def add_moderators(channel_type, channel_id, mod_ids) do
    update_channel(channel_type, channel_id, %{"add_moderators" => mod_ids})
  end

  def remove_moderators(channel_type, channel_id, mod_ids) do
    update_channel(channel_type, channel_id, %{"demote_moderators" => mod_ids})
  end

  defp parse_resp({:ok, %{"channel" => channel_info} = resp}) do
    {:ok,
     %__MODULE__{
       cid: channel_info["cid"],
       config: channel_info["config"],
       created_at: channel_info["created_at"],
       created_by: channel_info["created_by"],
       disabled: channel_info["disabled"],
       frozen: channel_info["frozen"],
       hidden: channel_info["hidden"],
       id: channel_info["id"],
       own_capabilities: channel_info["own_capabilities"],
       type: channel_info["type"],
       members: resp["members"],
       messages: resp["messages"]
     }}
  end

  defp parse_resp(resp), do: resp
end
