# frozen_string_literal: true

require "test_helper"

class WeatherComponentTest < ViewComponent::TestCase
  test "renders all the periods of the weather" do
    raw_data = JSON.parse(File.read("test/support/weather_warren.json"))
    periods = raw_data.map { |k, v| WeatherClient::GridPeriod.new(k["period"]) }
    address = "Warren Township, NJ"
    render_inline(WeatherComponent.new(address:, periods:))
    assert_selector "h2", text: "Weather for: #{address}"
    assert_selector "img", count: periods.count
  end
end
