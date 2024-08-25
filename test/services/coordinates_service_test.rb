require "test_helper"

class CoordinatesServiceTest < ActiveSupport::TestCase
  setup do
    @address = "Basking Ridge, NJ"
    @service = CoordinatesService.new(@address)
    @mock_coordinates = Struct.new(:lat, :lon, :valid?).new("40.7066", "-74.5499", true)
  end

  test "fetches coordinates from geocoder when not in database" do
    assert_nil Coordinate.find_by_normalized_address(@address)

    GeocoderClient.expects(:coordinates).with(@address).returns(@mock_coordinates)

    result = @service.call

    assert_equal @mock_coordinates, result
    assert_not_nil Coordinate.find_by_normalized_address(@address)

    stored_coordinate = Coordinate.find_by_normalized_address(@address)
    assert_equal @mock_coordinates.lat, stored_coordinate.lat
    assert_equal @mock_coordinates.lon, stored_coordinate.lon
  end

  test "returns coordinates from database when already exist" do
    Coordinate.create!(address: @address, lat: @mock_coordinates.lat, lon: @mock_coordinates.lon)

    GeocoderClient.expects(:coordinates).never

    result = @service.call

    assert_instance_of Coordinate, result
    assert_equal @mock_coordinates.lat, result.lat
    assert_equal @mock_coordinates.lon, result.lon
  end

  test "logs error when geocoder fails" do
    assert_nil Coordinate.find_by_normalized_address(@address)

    invalid_coordinates = Struct.new(:valid?).new(false)
    GeocoderClient.expects(:coordinates).with(@address).returns(invalid_coordinates)
    result = @service.call

    assert_equal invalid_coordinates, result
    assert_nil Coordinate.find_by_normalized_address(@address)
  end
end
