require "test_helper"

class CoordinatesServiceTest < ActiveSupport::TestCase
  setup do
    @address = "Basking Ridge, NJ"
    @mock_geocoder_client = Minitest::Mock.new
    @service = CoordinatesService.new(@address, geocoder_client: @mock_geocoder_client)
    @mock_coordinates = Struct.new(:lat, :lon, :valid?).new("40.7066", "-74.5499", true)
  end

  test "fetches coordinates from geocoder when not in database" do
    assert_nil Coordinate.find_by_normalized_address(@address)

    @mock_geocoder_client.expect(:coordinates, @mock_coordinates, [@address])

    assert_difference "Coordinate.count", 1 do
      result = @service.call

      assert_equal @mock_coordinates, result
      assert Coordinate.exists?(address: @address, lat: @mock_coordinates.lat, lon: @mock_coordinates.lon)
    end

    @mock_geocoder_client.verify
  end

  test "returns coordinates from database when already exist" do
    existing_coordinate = Coordinate.create!(address: @address, lat: @mock_coordinates.lat, lon: @mock_coordinates.lon)

    assert_no_difference "Coordinate.count" do
      result = @service.call

      assert_equal existing_coordinate, result
    end

    @mock_geocoder_client.verify
  end

  test "logs error when geocoder fails" do
    assert_nil Coordinate.find_by_normalized_address(@address)

    invalid_coordinates = Struct.new(:valid?).new(false)
    @mock_geocoder_client.expect(:coordinates, invalid_coordinates, [@address])

    assert_no_difference "Coordinate.count" do
      result = @service.call

      assert_equal invalid_coordinates, result
    end

    @mock_geocoder_client.verify
  end
end
