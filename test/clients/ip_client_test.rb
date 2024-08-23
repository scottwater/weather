require "test_helper"
class IpClientTest < ActiveSupport::TestCase
  test "IpClient#me" do
    VCR.use_cassette("ip") do
      response = IpClient.me
      assert_equal "72.68.111.45", response.ip
      assert_equal "Warren Township New Jersey, United States", response.location
    end
  end
end