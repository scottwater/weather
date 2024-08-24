require "test_helper"
class WeatherServiceTest < ActiveSupport::TestCase

  test "WeatherService#weather" do
    VCR.use_cassette("weather_service#warren_township_new_jersey") do
      service = WeatherService.new("Warren Township New Jersey")
      periods = service.weather
      assert_equal 14, periods.length
      assert_equal 2, periods.select(&:precipitation?).length
    end
  end

  test "WeatherService#weather with bad address" do
    VCR.use_cassette("weather_service#bad_address") do
      service = WeatherService.new("bad address")
      periods = service.weather
      assert_nil periods
    end
  end
end