# frozen_string_literal: true

class WeatherComponent < ApplicationViewComponent

  def initialize(address:, periods:)
    @address = address
    @periods = periods
  end

  def requires_initial_offset?(index)
    index == 0 && @periods&.first&.name == 'Tonight'
  end


end
