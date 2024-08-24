class ForecastController < ApplicationController
  def show
     weather_component_html = Rails.cache.fetch("weather_#{params[:address]}", expires_in: 5.minutes) do
      periods = WeatherService.new(params[:address]).weather
      WeatherComponent.new(address: params[:address], periods: periods).render_in(view_context)
    end
    render turbo_stream: turbo_stream.replace(
      "load_weather", weather_component_html
    )
  end
end
