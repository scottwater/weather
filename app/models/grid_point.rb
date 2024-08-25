class GridPoint < ApplicationRecord
  validates :lat, uniqueness: {scope: :lon, message: "and longitude combination already exists"}
end
