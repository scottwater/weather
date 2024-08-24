class ForecastController < ApplicationController
  def show
     weather_component_html = Rails.cache.fetch("weather_#{params[:address]}", expires_in: 5.minutes) do
      compontent = component_for_address(params[:address])
      compontent.render_in(view_context)
    end

    render turbo_stream: turbo_stream.replace(
      "load_weather", weather_component_html
    )
  end

  private

  def component_for_address(address)
    periods = fetch_periods_for_address(address)
    if periods&.any?
      WeatherComponent.new(address:, periods: periods)
    else
      NoWeatherComponent.new(address: )
    end
  end

  def fetch_periods_for_address(address)
    WeatherService.new(address).weather
  end
end
