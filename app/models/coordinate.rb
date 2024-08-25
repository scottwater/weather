class Coordinate < ApplicationRecord
  validates :address, presence: true, uniqueness: true
  validates :lat, presence: true
  validates :lon, presence: true
  normalizes :address, with: ->(value) { Coordinate.normalize_address(value) }

  def normalize_address
    self.class.normalize_address(address)
  end

  def self.find_by_normalized_address(address)
    find_by(address: normalize_address(address))
  end

  def self.normalize_address(address)
    address.gsub(/[^a-zA-Z0-9]+/, " ").strip.downcase
  end
end
