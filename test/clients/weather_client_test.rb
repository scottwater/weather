require "test_helper"
class WeatherClientTest < ActiveSupport::TestCase
  test "WeatherClient#point" do
    VCR.use_cassette("find_grid_point#warren_township_new_jersey") do
      coordinates = GeocoderClient::Coordinates.new([{
        "lat" => "40.63065715",
        "lon" => "-74.52266308479568"
      }])

      grid = WeatherClient.find_grid_point(coordinates)
      assert_equal "PHI", grid.grid_id
      assert_equal 67, grid.grid_x
      assert_equal 110, grid.grid_y
    end
  end

  test "WeatherClient#periods_by_grid_point" do
    VCR.use_cassette("periods_by_grid_point#warren_township_new_jersey") do
      grid = WeatherClient::GridPoint.new({"properties" => {
        "gridId" => "PHI",
        "gridX" => 67,
        "gridY" => 110
      }})

      periods = WeatherClient.periods_by_grid_point(grid)
      assert_equal 14, periods.length
      assert_equal 2, periods.count(&:precipitation?)
    end
  end

  test "WeatherClient Invalid points" do
    VCR.use_cassette("find_grid_point#bad_address") do
      coordinates = GeocoderClient::Coordinates.new([{
        "lat" => "bad",
        "lon" => "bad"
      }])
      grid = WeatherClient.find_grid_point(coordinates)
      assert_nil grid
    end
  end
end
