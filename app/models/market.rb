class Market < ApplicationRecord
  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count, presence: true
end
