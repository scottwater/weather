require "test_helper"

class CoordinateTest < ActiveSupport::TestCase
  test "should normalize the address" do
    coordinate = Coordinate.new(address: "Warren Township, NJ", lat: "40.63", lon: "-74.52")
    assert_equal "warren township nj", coordinate.address
  end

  test "should not allow duplicate addresses" do
    coordinate = Coordinate.create!(address: "Warren Township, NJ", lat: "40.63", lon: "-74.52")
    assert coordinate.valid?
    duplicate = Coordinate.new(address: "Warren Township, NJ", lat: "40.63", lon: "-74.52")
    refute duplicate.valid?
    assert_match(/taken/, duplicate.errors[:address].first)
  end
end
