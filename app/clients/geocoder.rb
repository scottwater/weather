class Geocoder
  include HTTParty
  base_uri "nominatim.openstreetmap.org:443"
  format :json


  Coordinates = Data.define(:data) do
    def latitude
      data&.dig(0, "lat")
    end

    def longitude
      data&.dig(0, "lon")
    end

    def valid?
      latitude && longitude
    end
  end

  def self.coordinates(address)
    response = self.get("/search", query: { q: address, format: "json" }, headers: { "User-Agent" => "WeatherApp" })
    Coordinates.new(response)
  end
end