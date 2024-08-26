class LocalWeatherService
  attr_reader :ip_address

  def initialize(ip_address, weather_service: WeatherService, ip_client: IpClient)
    @ip_address = ip_address
    @weather_service = weather_service
    @ip_client = ip_client
    Rails.logger.info "Looking up weather for IP: #{ip_address}"
  end

  def call
    @weather_service.new(address)&.call&.first
  end

  def address
    @address ||= find_address
  end

  private

  def find_address
    return IpAddress.find_by(ip: ip_address)&.address if IpAddress.exists?(ip: ip_address)

    Rails.logger.info "Looking up location for IP: #{ip_address}"
    address = @ip_client.lookup(ip_address)&.location || @ip_client.me&.location
    IpAddress.create(ip: ip_address, address: address) if address
    address
  end
end
