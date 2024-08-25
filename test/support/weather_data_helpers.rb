module WeatherDataHelpers
  def sample_weather_data
    raw_data = JSON.parse(File.read("test/support/weather_warren.json"))
    raw_data.map {|k,v| WeatherClient::GridPeriod.new(k["period"])}
  end
end