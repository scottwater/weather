class ForecastController < ApplicationController
  def show
    periods = Rails.cache.fetch("weather_#{params[:address]}", expires_in: 5.minutes) do
      WeatherService.new(params[:address]).weather
    end
    render turbo_stream: turbo_stream.replace(
      "load_weather",
      WeatherComponent.new(address: params[:address], periods: periods)
    )
  end
end
