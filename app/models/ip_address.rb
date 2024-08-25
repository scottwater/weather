class IpAddress < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
  validates :address, presence: true
end
