require "test_helper"

class LocalWeatherServiceTest < ActiveSupport::TestCase
  setup do
    @ip_address = "192.168.1.1"
    @service = LocalWeatherService.new(@ip_address)
  end

  test "initializes with ip address" do
    assert_equal @ip_address, @service.ip_address
  end

  test "falls back to IpClient.me when IpClient.lookup returns nil" do
    IpClient.expects(:lookup).with(@ip_address).returns(nil)
    IpClient.expects(:me).returns(Struct.new(:location).new("New York, NY"))
    WeatherService.any_instance.expects(:call).returns(["Sunny"])

    result = @service.call

    assert_equal "Sunny", result
    assert_equal "New York, NY", @service.address
  end

  test "uses IpClient.lookup when successful" do
    IpClient.expects(:lookup).with(@ip_address).returns(Struct.new(:location).new("Los Angeles, CA"))
    WeatherService.any_instance.expects(:call).returns(["Cloudy"])

    result = @service.call

    assert_equal "Cloudy", result
    assert_equal "Los Angeles, CA", @service.address
  end

  test "logs ip address to IpAddress table when not found" do
    IpClient.expects(:lookup).with(@ip_address).returns(Struct.new(:location).new("Chicago, IL"))
    WeatherService.any_instance.expects(:call).returns(["Rainy"])

    assert_difference -> { IpAddress.count }, 1 do
      @service.call
    end

    ip_address_record = IpAddress.last
    assert_equal @ip_address, ip_address_record.ip
    assert_equal "Chicago, IL", ip_address_record.address
  end

  test "does not create new IpAddress record on subsequent calls" do
    existing_address = "Portland, OR"
    IpAddress.create(ip: @ip_address, address: existing_address)

    assert_no_difference -> { IpAddress.count } do
      WeatherService.any_instance.expects(:call)
      @service.call
    end
  end
end
