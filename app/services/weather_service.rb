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
    if !defined?(@coordinates)
      Rails.logger.info "Looking up weather for coordinates for #{address}"
      @coordinates = CoordinatesService.new(address).call
    end
    @coordinates
  end

  def grid_point
    if coordinates.valid? && !defined?(@grid_point)
      Rails.logger.info "Looking up weather for grid point #{coordinates.lat}, #{coordinates.lon}"
      @grid_point = find_or_create_grid_point(coordinates)
    end

    @grid_point
  end

  def periods
    if grid_point && !defined?(@periods)
      Rails.logger.info "Looking up weather for periods for grid point #{grid_point.grid_id}, #{grid_point.grid_x}, #{grid_point.grid_y}"
      @periods = WeatherClient.periods_by_grid_point(grid_point)
    end

    @periods
  end

  def find_or_create_grid_point(coordinates)
    if coordinates.valid?
      GridPoint.find_by(lat: coordinates.lat, lon: coordinates.lon) || begin
        WeatherClient.find_grid_point(coordinates).tap do |grid_point|
          if grid_point
            Rails.logger.info "Creating grid point for #{coordinates.lat}, #{coordinates.lon}"
            GridPoint.create!(lat: coordinates.lat, lon: coordinates.lon, grid_id: grid_point.grid_id, grid_x: grid_point.grid_x, grid_y: grid_point.grid_y)
          else
            Rails.logger.error "Failed to create grid point for #{coordinates.lat}, #{coordinates.lon}"
          end
        end
      end
    end
  end
end
