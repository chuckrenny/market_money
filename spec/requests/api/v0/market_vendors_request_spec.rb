require 'rails_helper'

RSpec.describe 'Market Vendors path', type: :request do
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

  describe "API::V0::MarketVendors" do
    describe "POST /api/v0/market_vendors" do
      it "creates a new market-vendor association" do
        market = create(:market)
        vendor = create(:vendor)
  
        market_vendor_params = { market_id: market.id, vendor_id: vendor.id }
        headers = {"CONTENT_TYPE" => "application/json"}
  
        post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
        created_market_vendor = MarketVendor.last
  
        expect(response).to have_http_status(:created)
        expect(created_market_vendor.market_id).to eq(market.id)
        expect(created_market_vendor.vendor_id).to eq(vendor.id)
      end

      it 'cannot create a new market-vendor if an invalid market id is passed in sad path' do
        market = 987654321
        vendor = create(:vendor)
  
        market_vendor_params = { market_id: market, vendor_id: vendor.id }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
        expect(response).to_not be_successful
        expect(response.status).to eq(404) # Expecting bad_request
        
        data = JSON.parse(response.body, symbolize_names: true)
        # require 'pry';binding.pry
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:detail]).to eq("Market must exist")
      end   

      it 'cannot create a new market-vendor if an invalid vendor id is passed in sad path' do
        market = create(:market)
        vendor = 987654321
  
        market_vendor_params = { market_id: market.id, vendor_id: vendor }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
        expect(response).to_not be_successful
        expect(response.status).to eq(404) # Expecting bad_request
        # 404 :not_found
        # 400 :bad_request

        data = JSON.parse(response.body, symbolize_names: true)
#  require 'pry';binding.pry
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:detail]).to eq("Vendor must exist")
      end   

      it 'cannot create a new market-vendor if the same association already exists in sad path' do
        market = create(:market)
        vendor = create(:vendor)
      
        market_vendor_params = { market_id: market.id, vendor_id: vendor.id }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        # First POST request to create association
        post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
        expect(response).to have_http_status(:created)
      
        # Second POST request with same parameters
        post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
        expect(response).to_not be_successful
        expect(response.status).to eq(422) # Expecting unprocessable_entity
      
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:detail]).to include("Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
      end      
    end
  end
end
