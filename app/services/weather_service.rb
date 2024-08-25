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
    @coordinates ||= GeocoderClient.coordinates(address)
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


end