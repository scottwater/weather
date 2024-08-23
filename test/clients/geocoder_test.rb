require "test_helper"
class GeocoderTest < ActiveSupport::TestCase
  test "Geocoder#coordinates" do
    VCR.use_cassette("Warren Township New Jersey") do
      response = Geocoder.coordinates("Warren Township New Jersey")
      assert_match "40.63", response.latitude
      assert_match "-74.52", response.longitude
    end
  end

  test "Geocoder#coordinates with bad address" do
    VCR.use_cassette("bad_address") do
      response = Geocoder.coordinates("bad address")
      refute response.valid?
      assert_nil response.latitude
      assert_nil response.longitude
    end
  end
end