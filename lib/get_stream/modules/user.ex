defmodule GetStream.Modules.User do
  @moduledoc """
    Manage GetStream Users
  """
  alias GetStream.Request

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

  def upsert_user(users) when is_list(users) do
    with result when is_map(result) <- Enum.reduce(users, %{}, &prepare_upsert_user/2) do
      params = %{"users" => result}

      Request.new()
      |> Request.with_path("users")
      |> Request.with_token()
      |> Request.with_method(:post)
      |> Request.with_body(params)
      |> Request.send()
      |> parse_resp()
    end
  end

  def upsert_user(params) when is_map(params), do: upsert_user([params])

  def ban_user(_params) do
    {:ok, %__MODULE__{}}
  end

  defp prepare_upsert_user(%{id: user_id} = user, result)
       when is_binary(user_id) and is_map(result) do
    Map.put(result, user_id, user)
  end

  defp prepare_upsert_user(_, result) when is_map(result), do: {:error, "USER_ID_IS_REQUIRED"}
  defp prepare_upsert_user(_, result), do: result

  defp parse_resp({:ok, %{"users" => users} = resp}) do
    IO.inspect(resp: resp)

    {:ok, users}
  end

  defp parse_resp(resp), do: resp
end
