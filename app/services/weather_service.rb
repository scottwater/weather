# Executes the various client apis we rely on to convert an
# address into a weather forecast
class WeatherService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def weather
    periods
  end

  private

  def coordinates
    @coordinates ||= find_or_create_coordinate(address)
  end

  def grid_point
    if coordinates.valid? && !defined?(@grid_point)
      @grid_point = WeatherClient.find_grid_point(coordinates)
    end

    @grid_point
  end

  def periods
    if grid_point && !defined?(@periods)
      @periods = WeatherClient.periods_by_grid_point(grid_point)
    end

    @periods
  end

  def find_or_create_coordinate(address)
    Coordinate.find_by_normalized_address(address) || begin
      GeocoderClient.coordinates(address).tap do |geo_coordinates|
        if geo_coordinates.valid?
          Rails.logger.info "Creating coordinate for #{address} - #{geo_coordinates.lat}, #{geo_coordinates.lon}"
          Coordinate.create!(address: address, lat: geo_coordinates.lat, lon: geo_coordinates.lon)
        else
          Rails.logger.error "Failed to create coordinate for #{address}"
        end
      end
    end
  end
end
