class GeocoderClient < ApplicationClient
  base_uri "nominatim.openstreetmap.org:443"
  format :json


  Coordinates = Data.define(:data) do
    def lat
      data&.dig(0, "lat")
    end

    def lon
      data&.dig(0, "lon")
    end

    def valid?
      lat && lon
    end
  end

  def self.coordinates(address)
    response = self.get("/search", query: { q: address, format: "json" }, headers: { "User-Agent" => "WeatherApp" })
    Coordinates.new(response)
  end
end