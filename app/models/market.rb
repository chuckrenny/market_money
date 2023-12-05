class Market < ApplicationRecord
  validates_presence_of :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end
end
