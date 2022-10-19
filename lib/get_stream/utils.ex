defmodule GetStream.Utils do
  @moduledoc """
    utility function 
  """

  def put_created_by_in_data(params) do
    created_by_info = %{"created_by" => %{"id" => "enthu-server"}}

    data =
      case Map.get(params, "data") do
        d when is_map(d) -> Map.merge(d, created_by_info)
        _ -> created_by_info
      end

    Map.put(params, "data", data)
  end
end
