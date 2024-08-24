# frozen_string_literal: true

class NoWeatherComponent < ViewComponent::Base
  def initialize(address:)
    @address = address
  end

end
