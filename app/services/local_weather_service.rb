class LocalWeatherService
  attr_reader :ip_address, :address
  def initialize(ip_address)
    @ip_address = ip_address
    Rails.logger.info "Looking up weather for IP: #{ip_address}"
  end

  def call
    # Falling back on .me is mostly just for testing. This will essentially
    # default to the server address which might be useful in development
    @address = find_address
    Rails.logger.info "Looking up weather for location: #{address}"
    if address
      WeatherService.new(address).call&.first
    end
  end

  private

  def find_address
    if (ipa = IpAddress.find_by(ip: ip_address))
      ipa.address
    else
      Rails.logger.info "Looking up weather for location: #{address}"
      (IpClient.lookup(ip_address)&.location || IpClient.me&.location).tap do |address|
        IpAddress.create(ip: ip_address, address: address) if address
      end
    end
  end
end
