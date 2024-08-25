class CoordinatesService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def call
    Coordinate.find_by_normalized_address(address) || query_geocoder
  end

  private

  def query_geocoder
    GeocoderClient.coordinates(address).tap do |geo_coordinates|
      log_geocoder_response(geo_coordinates)
    end
  end

  def log_geocoder_response(geo_coordinates)
    if geo_coordinates.valid?
      Rails.logger.info "Found geocoder response for #{address} - #{geo_coordinates.lat}, #{geo_coordinates.lon}"
      Coordinate.create!(address: address, lat: geo_coordinates.lat, lon: geo_coordinates.lon)
    else
      Rails.logger.error "Failed to find geocoder response for #{address}"
    end
  end
end
