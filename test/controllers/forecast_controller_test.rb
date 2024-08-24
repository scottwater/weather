require "test_helper"

class ForecastControllerTest < ActionDispatch::IntegrationTest
  test "should get weather for valid address" do
    raw_data = JSON.parse(File.read("test/support/weather_warren.json"))
    periods = raw_data.map {|k,v| WeatherClient::GridPeriod.new(k["period"])}
    ForecastController.any_instance.stubs(:fetch_periods_for_address).returns(periods)

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
