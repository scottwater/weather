# frozen_string_literal: true

require "test_helper"

class HeaderComponentTest < ViewComponent::TestCase
  test "render header and nav" do
    render_inline(HeaderComponent.new)
    assert_selector("header")
    assert_selector("nav")
  end
end
