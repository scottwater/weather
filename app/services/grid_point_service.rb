class GridPointService
  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end

  def call
    GridPoint.find_by(lat: coordinates.lat, lon: coordinates.lon) || query_grid_point_client
  end

  private

  def query_grid_point_client
    WeatherClient.find_grid_point(coordinates).tap do |grid_point|
      log_grid_point_client_response(grid_point)
    end
  end

  def log_grid_point_client_response(grid_point)
    if grid_point
      Rails.logger.info "Found grid point client response for #{coordinates.lat}, #{coordinates.lon} - #{grid_point.grid_id}, #{grid_point.grid_x}, #{grid_point.grid_y}"
      GridPoint.create!(lat: coordinates.lat, lon: coordinates.lon, grid_id: grid_point.grid_id, grid_x: grid_point.grid_x, grid_y: grid_point.grid_y)
    else
      Rails.logger.error "Failed to find grid point client response for #{coordinates.lat}, #{coordinates.lon}"
    end
  end
end
