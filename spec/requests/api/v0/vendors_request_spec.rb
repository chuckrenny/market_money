require 'rails_helper'

describe 'Vendors Request' do
  describe 'Get All Markets index /api/v0/vendors' do
    it 'sends one vendor during happy path' do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
    
      expect(vendor[:data]).to have_key(:id)
      expect(vendor[:data][:id]).to be_an(String)

      expect(vendor[:data][:attributes]).to have_key(:name)
      expect(vendor[:data][:attributes][:name]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:description)
      expect(vendor[:data][:attributes][:description]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:contact_name)
      expect(vendor[:data][:attributes][:contact_name]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:contact_phone)
      expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
      expect(vendor[:data][:attributes][:credit_accepted]).to be(true).or be(false)
    end

    it 'cannot get a market during sad path' do
      invalid_id = 123123123
    
      get "/api/v0/vendors/#{invalid_id}"
    
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
    end
  end
end
