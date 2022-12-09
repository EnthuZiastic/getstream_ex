defmodule GetStream.Modules.Message do
  @moduledoc """
  Manage GetStream Messages
  """
  alias GetStream.Request

  @type opts() :: [skip_push: boolean()]

  @spec create_message(String.t(), String.t(), map, __MODULE__.opts()) ::
          {:error, any} | {:ok, any}
  def create_message(channel_type, channel_id, message_params, opts \\ []) do
    skip_push = Keyword.get(opts, :skip_push, false)
    params = %{"message" => message_params, "skip_push" => skip_push}

    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}/message")
    |> Request.with_token()
    |> Request.with_method(:post)
    |> Request.with_body(params)
    |> Request.send()
    |> parse_resp()
  end

  @spec upload_file(any, any, any) :: {:error, any} | {:ok, any}
  def upload_file(channel_type, channel_id, params) do
    Request.new()
    |> Request.with_path("channels/#{channel_type}/#{channel_id}/file")
    |> Request.with_token()
    |> Request.with_method(:post)
    |> Request.with_body(params)
    |> Request.send()
    |> parse_resp()
  end

  @spec update_attachment(String.t(), map(), String.t()) :: any
  def update_attachment(message_id, new_attachment, user_id) do
    Request.new()
    |> Request.with_path("messages/#{message_id}")
    |> Request.with_token()
    |> Request.with_method(:put)
    |> Request.with_body(%{
      "set" => %{"attachments" => [new_attachment]},
      "user" => %{"id" => user_id}
    })
    |> Request.send()
    |> parse_resp()
  end

  defp parse_resp({:ok, %{"message" => message}}) do
    {:ok, message}
  end

  defp parse_resp({:ok, %{"file" => file}}) do
    {:ok, file}
  end

  defp parse_resp(resp), do: resp
end
