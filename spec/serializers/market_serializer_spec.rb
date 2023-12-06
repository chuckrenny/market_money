require 'rails_helper'

RSpec.describe MarketSerializer, type: :request do
  describe 'Serializing' do
      it 'can connect' do
      create_list(:market, 5)

      get "/api/v0/markets"

      expect(response).to be_successful
      data = JSON.parse(response.body, symbolize_names: true)
      # require 'pry';binding.pry
      store = data[:data][0]

      expect(store).to have_key(:id)
      expect(store[:id]).to be_a String
    end
  end
end