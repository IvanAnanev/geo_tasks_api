defmodule Gt.Utils do
  @moduledoc """
  Utils module
  """
  @srid 4326
  @spec geo_point(lat :: float(), lng :: float()) :: Geo.Point.t()
  def geo_point(lat, lng) do
    %Geo.Point{coordinates: {lat, lng}, srid: @srid}
  end
end
