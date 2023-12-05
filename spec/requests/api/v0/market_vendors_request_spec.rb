require 'rails_helper'

describe 'Market Vendors Request /api/v0/markets/:id/vendors' do
  describe 'Get All Vendors from a Market' do
    it 'sends a list of markets during happy path' do
      market = create(:market)
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      vendor_3 = create(:vendor)

      MarketVendor.create!(market: market, vendor: vendor_1)
      MarketVendor.create!(market: market, vendor: vendor_2)
      MarketVendor.create!(market: market, vendor: vendor_3)
      
      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful

      vendors = JSON.parse(response.body, symbolize_names: true)
      # require 'pry';binding.pry
      expect(vendors[:data].count).to eq(3)

      vendors[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be(true).or be(false)
      end
    end

    it 'cannot get vendors from a market during sad path' do
      invalid_id = 123123123
    
      get "/api/v0/markets/#{invalid_id}/vendors"
    
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:message]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
    end
  end
end