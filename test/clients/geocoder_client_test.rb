require "test_helper"
class GeocoderClientClientTest < ActiveSupport::TestCase
  test "GeocoderClient#coordinates" do
    VCR.use_cassette("Warren Township New Jersey") do
      response = GeocoderClient.coordinates("Warren Township New Jersey")
      assert_match "40.63", response.lat
      assert_match "-74.52", response.lon
    end
  end

  test "GeocoderClient#coordinates with a zip code" do
    VCR.use_cassette("90210") do
      response = GeocoderClient.coordinates("90210")
      assert_match "48.35", response.lat
      assert_match "22.36", response.lon
    end
  end

  test "GeocoderClient#coordinates with bad address" do
    VCR.use_cassette("bad_address") do
      response = GeocoderClient.coordinates("bad address")
      refute response.valid?
      assert_nil response.lat
      assert_nil response.lon
    end
  end
end
