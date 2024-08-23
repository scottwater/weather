# frozen_string_literal: true

require "test_helper"

class SearchBoxComponentTest < ViewComponent::TestCase
  test "renders the seeach box" do
    render_inline(SearchBoxComponent.new)
    assert_selector("form")
  end
end
