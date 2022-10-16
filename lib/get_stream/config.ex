defmodule GetStream.Config do
  @moduledoc """
    Configuration for GetStream 
  """

  defstruct [:region, :key, :secret]

  @type t() :: %__MODULE__{
    region: String.t(),
    key: String.t(),
    secret: String.t()
  }


  @doc """
    returns configuration for GetStream

    ## Examples
      
      iex> get_config()
      %Config{region: "some_region", key: "some_key", secret: "some_secret"}

  """

  @spec get_config() :: Config.t()
  def get_config do
    region = Application.get_env(:getstream, :region) |> resolve_value()
    key = Application.get_env(:getstream, :key) |> resolve_value()
    secret = Application.get_env(:getstream, :secret) |> resolve_value()

    %__MODULE__{
      region: region,
      key: key,
      secret: secret

    }
  end

  defp resolve_value ({:system, env})  do
    System.get_env(env)
  end

  defp resolve_value(value), do: value
end
