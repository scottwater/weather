class LocalWeatherController < ApplicationController
  def create
    if (local_weather = fetch_local_weather(request.remote_ip))
      render turbo_stream: turbo_stream.replace("local_weather", LocalWeatherComponent.new(period: local_weather.period, address: local_weather.address))
    else
      # This will fail silently and get logged in the console
      render plain: "No local weather could be inferred for this request", status: :not_found
    end
  end

  private

  LocalWeather = Data.define(:period, :address)
  def fetch_local_weather(ip_address)
    Rails.cache.fetch("local#{ip_address}", expires_in: 5.minutes) do
      local_weather_service = LocalWeatherService.new(ip_address)
      period = local_weather_service.call
      if period
        LocalWeather.new(period:, address: local_weather_service.address)
      end
    end
  end
end
