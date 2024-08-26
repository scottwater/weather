# frozen_string_literal: true

require "test_helper"

class SearchBoxComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers
  test "renders the seeach box" do
    render_inline(SearchBoxComponent.new)
    assert_selector("input[name='address']")
    assert_selector("form[action='#{weather_path}']")
  end
end
