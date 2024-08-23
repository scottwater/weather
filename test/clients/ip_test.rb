require "test_helper"
class IpTest < ActiveSupport::TestCase
  test "Ip#me" do
    VCR.use_cassette("ip") do
      response = Ip.me
      assert_equal "72.68.111.45", response.ip
      assert_equal "Warren Township New Jersey, United States", response.location
    end
  end
end