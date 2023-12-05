require 'rails_helper'

describe 'Markets Request' do
  describe 'Get All Markets index /api/v0/markets' do
    it 'sends a list of markets' do
      create_list(:market, 3)

      get '/api/v0/markets'

      expect(response).to be_successful

      parsed_markets = JSON.parse(response.body, symbolize_names: true)

      # require 'pry';binding.pry
      expect(parsed_markets[:data].count).to eq(3)
      parsed_markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)

        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)

        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)

        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)

        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)

        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_an(String)

        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_an(String)

        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_an(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_an(String)
# require 'pry';binding.pry
        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe 'Get One Market Show /api/v0/markets/:id' do
    it 'can get one market by its id during happy path' do
      market = create(:market)
    
      get "/api/v0/markets/#{market.id}"
    
      parsed_market = JSON.parse(response.body, symbolize_names: true)
    
      expect(response).to be_successful
    # require 'pry';binding.pry
      expect(parsed_market[:data]).to have_key(:id)
      expect(parsed_market[:data][:id]).to be_an(String)

      expect(parsed_market[:data][:attributes]).to have_key(:name)
      expect(parsed_market[:data][:attributes][:name]).to be_a(String)

      expect(parsed_market[:data][:attributes]).to have_key(:street)
      expect(parsed_market[:data][:attributes][:street]).to be_a(String)

      expect(parsed_market[:data][:attributes]).to have_key(:city)
      expect(parsed_market[:data][:attributes][:city]).to be_a(String)

      expect(parsed_market[:data][:attributes]).to have_key(:county)
      expect(parsed_market[:data][:attributes][:county]).to be_a(String)

      expect(parsed_market[:data][:attributes]).to have_key(:state)
      expect(parsed_market[:data][:attributes][:state]).to be_an(String)

      expect(parsed_market[:data][:attributes]).to have_key(:zip)
      expect(parsed_market[:data][:attributes][:zip]).to be_an(String)

      expect(parsed_market[:data][:attributes]).to have_key(:lat)
      expect(parsed_market[:data][:attributes][:lat]).to be_an(String)


      expect(parsed_market[:data][:attributes]).to have_key(:lon)
      expect(parsed_market[:data][:attributes][:lon]).to be_an(String)

      expect(parsed_market[:data][:attributes]).to have_key(:vendor_count)
      expect(parsed_market[:data][:attributes][:vendor_count]).to be_an(Integer)
    end

    it 'cannot get a market during sad path' do
      invalid_id = 123123123
    
      get "/api/v0/markets/#{invalid_id}"
    
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:message]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
    end
  end
end