require "test_helper"
class GeocoderClientClientTest < ActiveSupport::TestCase
  test "GeocoderClient#coordinates" do
    VCR.use_cassette("Warren Township New Jersey") do
      response = GeocoderClient.coordinates("Warren Township New Jersey")
      assert_match "40.63", response.latitude
      assert_match "-74.52", response.longitude
    end
  end

  test "GeocoderClient#coordinates with a zip code" do
    VCR.use_cassette("90210") do
      response = GeocoderClient.coordinates("90210")
      assert_match "48.35", response.latitude
      assert_match "22.36", response.longitude
    end
  end

  test "GeocoderClient#coordinates with bad address" do
    VCR.use_cassette("bad_address") do
      response = GeocoderClient.coordinates("bad address")
      refute response.valid?
      assert_nil response.latitude
      assert_nil response.longitude
    end
  end
end