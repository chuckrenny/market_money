require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe "relationships" do
    it { should have_many(:market_vendors)}
    it { should have_many(:vendors).through(:market_vendors)}
  end

  describe "#instance_method" do
    describe "#vendor_count" do
      it "returns the correct number of associated vendors" do
        market = create(:market)
        3.times do
          vendor = create(:vendor)
          MarketVendor.create!(market: market, vendor: vendor)
        end

        expect(market.vendor_count).to eq(3)
      end
    end
  end
end