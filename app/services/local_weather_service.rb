class LocalWeatherService
  attr_reader :ip_address, :address
  def initialize(ip_address)
    @ip_address = ip_address
  end

  def weather
    @address = IpClient.lookup(ip_address)&.location || IpClient.me&.location
    Rails.logger.info "Looking up weather for location: #{address}"
    if address
      WeatherService.new(address).weather&.first
    end
  end
end