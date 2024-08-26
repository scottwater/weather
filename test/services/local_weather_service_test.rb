require "test_helper"

class LocalWeatherServiceTest < ActiveSupport::TestCase
  setup do
    @ip_address = "192.168.1.1"
    @mock_weather_service = Minitest::Mock.new
    @mock_ip_client = Minitest::Mock.new
    @service = LocalWeatherService.new(@ip_address, weather_service: @mock_weather_service, ip_client: @mock_ip_client)
  end

  test "initializes with ip address" do
    assert_equal @ip_address, @service.ip_address
  end

  test "falls back to IpClient.me when IpClient.lookup returns nil" do
    @mock_ip_client.expect :lookup, nil, [@ip_address]
    @mock_ip_client.expect :me, Struct.new(:location).new("New York, NY")
    @mock_weather_service.expect :new, Minitest::Mock.new.expect(:call, ["Sunny"]), ["New York, NY"]

    result = @service.call

    assert_equal "Sunny", result
    assert_equal "New York, NY", @service.address
    @mock_ip_client.verify
    @mock_weather_service.verify
  end

  test "uses IpClient.lookup when successful" do
    @mock_ip_client.expect :lookup, Struct.new(:location).new("Los Angeles, CA"), [@ip_address]
    @mock_weather_service.expect :new, Minitest::Mock.new.expect(:call, ["Cloudy"]), ["Los Angeles, CA"]

    result = @service.call

    assert_equal "Cloudy", result
    assert_equal "Los Angeles, CA", @service.address
    @mock_ip_client.verify
    @mock_weather_service.verify
  end

  test "logs ip address to IpAddress table when not found" do
    @mock_ip_client.expect :lookup, Struct.new(:location).new("Chicago, IL"), [@ip_address]
    @mock_weather_service.expect :new, Minitest::Mock.new.expect(:call, ["Rainy"]), ["Chicago, IL"]

    assert_difference -> { IpAddress.count }, 1 do
      @service.call
    end

    ip_address_record = IpAddress.last
    assert_equal @ip_address, ip_address_record.ip
    assert_equal "Chicago, IL", ip_address_record.address
    @mock_ip_client.verify
    @mock_weather_service.verify
  end

  test "does not create new IpAddress record on subsequent calls" do
    existing_address = "Portland, OR"
    IpAddress.create(ip: @ip_address, address: existing_address)

    @mock_weather_service.expect :new, Minitest::Mock.new.expect(:call, ["Sunny"]), [existing_address]

    assert_no_difference -> { IpAddress.count } do
      @service.call
    end

    @mock_weather_service.verify
  end
end
