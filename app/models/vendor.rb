class Vendor < ApplicationRecord
  validates :name, :description, :contact_name, :contact_phone, presence: true
  validate :credit_accepted_boolean, on: :create
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  def credit_accepted_boolean
    unless [true, false].include?(credit_accepted)
      errors.add(:credit_accepted, "must be boolean")
    end
  end
end
