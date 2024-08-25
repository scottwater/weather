require "test_helper"

class GridPointTest < ActiveSupport::TestCase
  test "should only allow unique lat lon combinations" do
    grid_point = GridPoint.create!(lat: "33.63", lon: "-74.52", grid_id: "PHI", grid_x: 67, grid_y: 110)
    assert grid_point.valid?
    duplicate = GridPoint.new(lat: "33.63", lon: "-74.52", grid_id: "PHI", grid_x: 67, grid_y: 110)
    refute duplicate.valid?
    assert_match(/already exists/, duplicate.errors[:lat].first)
  end
end
