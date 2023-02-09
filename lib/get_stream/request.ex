defmodule GetStream.Request do
  @moduledoc """
    handle API request to GetStream
  """

  @default_headers [
    {"content-type", "application/json"},
    {"Stream-Auth-Type", "jwt"}
  ]

  defstruct [:url, :path, :method, :headers, :params, :body, :options, :token]

  alias GetStream.Signer
  alias GetStream.Config

  @type t() :: %__MODULE__{
          url: String.t(),
          path: String.t(),
          method: HTTPoison.method(),
          headers: HTTPoison.headers(),
          params: map(),
          body: map(),
          options: list(),
          token: String.t()
        }

  def new do
    struct(%__MODULE__{headers: @default_headers})
  end

  def with_method(%__MODULE__{} = r, method) do
    %{r | method: method}
  end

  def with_path(%__MODULE__{} = r, path) do
    %{r | path: path}
  end

  def with_body(%__MODULE__{} = r, body) do
    %{r | body: body}
  end

  def with_token(%__MODULE__{} = r) do
    token = Signer.server_token()
    headers = [{"Authorization", token} | r.headers]
    %{r | token: token, headers: headers}
  end

  def with_params(%__MODULE__{} = r, params) do
    %{r | params: params}
  end

  def send(%__MODULE__{} = r) do
    url = construct_url(r)

    body =
      case r.body do
        body when is_map(body) -> Jason.encode!(body)
        body when is_binary(body) -> body
        nil -> ""
      end

    HTTPoison.request(r.method, url, body, r.headers)
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body, status_code: code}})
       when code in [200, 201] do
    {:ok, json_or_value(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body}}) do
    {:error, json_or_value(body)}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, json_or_value(reason)}
  end

  defp json_or_value(data) when is_binary(data) do
    case Jason.decode(data) do
      {:ok, parsed_value} -> parsed_value
      _ -> data
    end
  end

  defp json_or_value(data), do: data

  defp construct_url(%__MODULE__{} = r) do
    cfg = Config.get_config()
    # "https://#{cfg.region}-api.stream-io-api.com/api/#{@version}/#{r.path}"
    "https://chat.stream-io-api.com/#{r.path}?api_key=#{cfg.key}"
  end
end
