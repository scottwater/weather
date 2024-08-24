require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home page works" do
    get root_path
    assert_response :success
    assert_select "h1", /fetching/i
  end
end
