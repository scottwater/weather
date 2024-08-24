# frozen_string_literal: true

class SearchBoxComponent < ApplicationViewComponent
  def initialize(address = nil)
    @address = address
  end
end
