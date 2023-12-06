require 'rails_helper'

RSpec.describe VendorSerializer, type: :request do
  describe 'Serializing' do
      it 'can connect' do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      data = JSON.parse(response.body, symbolize_names: true)
      # require 'pry';binding.pry
      vendor = data[:data]

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a String
    end
  end
end