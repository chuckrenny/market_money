require 'rails_helper'

describe 'Markets API' do
  describe 'Get All Markets index' do
    it 'sends a list of markets' do
      create_list(:market, 3)

      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(Integer)

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)

        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)

        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)

        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_an(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_an(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_an(String)


        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_an(String)

        expect(market).to have_key(:vendor_count)
        expect(market[:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe 'Get One Market Show' do
    it 'can get one market by its id during happy path' do
      market = create(:market)
    
      get "/api/v0/markets/#{market.id}"
    
      market = JSON.parse(response.body, symbolize_names: true)
    
      expect(response).to be_successful
    
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_an(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_an(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)


      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_an(Integer)
    end

    it 'cannot get a market by its id during sad path' do
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