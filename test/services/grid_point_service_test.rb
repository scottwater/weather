require "test_helper"

class GridPointServiceTest < ActiveSupport::TestCase
  setup do
    @coordinates = Struct.new(:lat, :lon).new("40.7064088", "-74.5492725")
    @service = GridPointService.new(@coordinates)
  end

  test "fetches grid point from API when not in database" do
    mock_grid_point = Struct.new(:grid_id, :grid_x, :grid_y).new("ABC", 1, 2)

    WeatherClient.expects(:find_grid_point).with(@coordinates).returns(mock_grid_point)

    assert_difference "GridPoint.count", 1 do
      result = @service.call

      assert_equal mock_grid_point, result
      assert GridPoint.exists?(lat: @coordinates.lat, lon: @coordinates.lon, grid_id: "ABC", grid_x: 1, grid_y: 2)
    end
  end

  test "returns existing grid point from database without calling API" do
    existing_grid_point = GridPoint.create!(lat: @coordinates.lat, lon: @coordinates.lon, grid_id: "XYZ", grid_x: 3, grid_y: 4)

    WeatherClient.expects(:find_grid_point).never

    assert_no_difference "GridPoint.count" do
      result = @service.call

      assert_equal existing_grid_point, result
    end
  end

  test "logs error when API fails to find grid point" do
    WeatherClient.expects(:find_grid_point).with(@coordinates).returns(nil)

    assert_no_difference "GridPoint.count" do
      result = @service.call

      assert_nil result
    end
  end
end
