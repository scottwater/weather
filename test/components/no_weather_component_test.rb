# frozen_string_literal: true

require "test_helper"

class NoWeatherComponentTest < ViewComponent::TestCase
  test "displays the 404 message" do
    render_inline(NoWeatherComponent.new(address: "bad"))
    assert_text(/sorry/i)
    assert_text(/404/)

  end
end
