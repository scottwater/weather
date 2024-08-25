# frozen_string_literal: true

class LocalWeatherComponent < ApplicationViewComponent
  attr_reader :period, :address
  def initialize(period:, address:)
    @period = period
    @address = address
  end
end
