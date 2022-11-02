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

  @spec user_token(binary(), non_neg_integer(), non_neg_integer()) :: binary()
  def user_token(user_id, exp, iat)
      when is_binary(user_id) and is_number(exp) and is_number(iat) and exp > 0 and iat > 0 do
    payload = %{"user_id" => user_id, "exp" => exp, "iat" => iat}

    secret_key =
      case Config.get_config() do
        %{secret: secret} when is_binary(secret) -> secret
        _ -> raise "Secret not found in getstream config"
      end

    signer = Joken.Signer.create("HS256", secret_key)
    Token.generate_and_sign!(payload, signer)
  end
end
