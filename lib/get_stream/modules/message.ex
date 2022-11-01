defmodule GetStream.Modules.Message do
  @moduledoc """
  Manage GetStream Messages
  """
  alias GetStream.Request

  def create_message(channel_type, channel_id, params) do
    params = %{"message" => params}

    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}/message")
    |> Request.with_token()
    |> Request.with_method(:post)
    |> Request.with_body(params)
    |> Request.send()
    |> parse_resp()
  end

  def create_message(channel_type, channel_id, user_id, content) do
    params = %{"text" => content, "user_id" => user_id}
    create_message(channel_type, channel_id, params)
  end

  defp parse_resp({:ok, %{"message" => message} = resp}) do
    IO.inspect(resp: resp)
    {:ok, message}
  end

  defp parse_resp(resp), do: resp
end
