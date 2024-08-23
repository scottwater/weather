require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "the truth" do
    get root_path
    assert_response :success
    assert_select "h1", "Welcome to the Home Page"
  end
end
