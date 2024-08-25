require "test_helper"
require "support/weather_data_helpers"
class ForecastControllerTest < ActionDispatch::IntegrationTest
  include WeatherDataHelpers
  test "should get weather for valid address" do
    ForecastController.any_instance.stubs(:fetch_periods_for_address).returns(sample_weather_data)

    get forecast_path("Warren Township, NJ"), xhr: true
    assert_response :success
    assert_match(/with a low around 63/i, @response.body)
    assert_no_match(/Sorry/, @response.body)
  end

  test "should handle no weather data" do
    ForecastController.any_instance.stubs(:fetch_periods_for_address).returns([])
    get forecast_path("No Weather City"), xhr: true
    assert_response :success
    assert_match(/Sorry/, @response.body)
  end
end
