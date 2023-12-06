require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
  end

  describe "relationships" do
    it { should have_many(:market_vendors)}
    it { should have_many(:markets).through(:market_vendors)}
  end

  describe 'credit_accepted validation' do
    it 'is valid when credit_accepted is true' do
      vendor = Vendor.new(credit_accepted: true)
      vendor.valid?
      expect(vendor.errors[:credit_accepted]).to be_empty
    end

    it 'is valid when credit_accepted is false' do
      vendor = Vendor.new(credit_accepted: false)
      vendor.valid?
      expect(vendor.errors[:credit_accepted]).to be_empty
    end

    it 'is not valid when credit_accepted is not true or false' do
      vendor = Vendor.new(credit_accepted: nil)
      vendor.valid?
      expect(vendor.errors[:credit_accepted]).to include("must be boolean")
    end
  end
end