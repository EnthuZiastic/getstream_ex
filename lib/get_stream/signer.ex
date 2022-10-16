defmodule GetStream.Signer do
  @moduledoc """
    signs token
  """
  alias GetStream.Token

  alias GetStream.Config

  @default_payload %{
    "resource" => "*",
    "action" => "*",
    "feed_id" => "*"
  }

  @spec server_token(map()) :: String.t()
  def server_token(payload \\ @default_payload) do
    secret_key = Config.get_config().secret
    signer = Joken.Signer.create("HS256", secret_key)
    {:ok, token, _claims} = Token.generate_and_sign(payload, signer)
    token
  end
end
