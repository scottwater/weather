class WeatherClient
  include HTTParty
  base_uri "api.weather.gov:443"
  format :json

  GridPoint = Data.define(:data) do
    def grid_id = data&.dig("properties", "gridId")
    def grid_x = data&.dig("properties", "gridX")
    def grid_y = data&.dig("properties", "gridY")
  end

  def self.find_grid_point(coordinates)
    point_path = "/points/#{coordinates.latitude},#{coordinates.longitude}"
    response = self.get(point_path)
    if response.ok?
      GridPoint.new(response)
    else
      Rails.logger.error("Failed to find grid point for #{coordinates.latitude}, #{coordinates.longitude} - #{response.code}")
      nil
    end
  end

  GridPeriod = Data.define(:period) do
    def number = period&.dig("number")
    def name = period&.dig("name")
    def isDayTime? = period&.dig("isDayTime")
    def temperature = period&.dig("temperature")
    def temperatureUnit = period&.dig("temperatureUnit")
    def temperatureTrend = period&.dig("temperatureTrend")
    def probabilityOfPrecipitation = period&.dig("probabilityOfPrecipitation", "value") || 0
    def precipitation? = !probabilityOfPrecipitation.zero?
    def windSpeed = period&.dig("windSpeed")
    def windDirection = period&.dig("windDirection")
    def icon = period&.dig("icon")
    def shortForecast = period&.dig("shortForecast")
    def detailedForecast = period&.dig("detailedForecast")
  end

  def self.periods_by_grid_point(grid, type_of_point: "forecast")
    grid_path = "/gridpoints/#{grid.grid_id}/#{grid.grid_x},#{grid.grid_y}/#{type_of_point}"
    response = self.get(grid_path)
    if response.ok?
      response
        .dig("properties", "periods")
        .map { |period| GridPeriod.new(period) }
    else
      Rails.logger.error("Failed to find grid point for #{grid.grid_id}, #{grid.grid_x}, #{grid.grid_y} - #{response.code}")
      nil
    end
  end
end