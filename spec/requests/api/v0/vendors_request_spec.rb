require 'rails_helper'

RSpec.describe '/api/v0/vendors path', type: :request do
  describe 'Vendors Request' do
    describe 'Get All Markets index /api/v0/vendors/:id' do
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

      it 'cannot get a vendor during sad path' do
        invalid_id = 123123123
      
        get "/api/v0/vendors/#{invalid_id}"
      
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
      end
    end

    describe "Create a New Vendor /api/v0/vendors#create path" do
      it "can create a new vendor" do
        vendor_params = ({
          name: 'Yang Express',
          description: 'Premier Chinese Takeout',
          contact_name: 'Michelle Yang',
          contact_phone: '2135702926',
          credit_accepted: true
        })
  
        headers = {"CONTENT_TYPE" => "application/json"}
  
        # We include this header to make sure that these params are passed as JSON rather than as plain text
        post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
        created_vendor = Vendor.last
  
        expect(response).to be_successful
        # require 'pry';binding.pry
        expect(created_vendor.name).to eq(vendor_params[:name])
        expect(created_vendor.description).to eq(vendor_params[:description])
        expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
        expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
        expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
      end

      it 'cannot create a new vendor during sad path' do
        vendor_params = ({
          name: 'Yang Express',
          description: 'Premier Chinese Takeout',
          credit_accepted: true
        })

        headers = {"CONTENT_TYPE" => "application/json"}
      
        post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
      
        expect(response).to_not be_successful
        expect(response.status).to eq(400) # Expecting bad_request
        
        data = JSON.parse(response.body, symbolize_names: true)
        # require 'pry';binding.pry
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].join(', ')).to eq("Contact name can't be blank, Contact phone can't be blank")
      end      
    end

    describe "Can edit a Vendor /api/v0/vendors/:id#update path" do
      it "can update an existing vendor" do
        id = create(:vendor).id
        previous_name = Vendor.last.name
        vendor_params = { name: "Updated Vendor Name"}
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
        vendor = Vendor.find_by(id: id)
  
        expect(response).to be_successful
        expect(vendor.name).to_not eq(previous_name)
        expect(vendor.name).to eq("Updated Vendor Name")
      end

      it 'cannot get a vendor with invalid id during sad path' do
        invalid_id = 123123123
        vendor_params = { contact_name: 'Invalid Vendor', credit_accepted: false }
        headers = {"CONTENT_TYPE" => "application/json"}
        
        patch "/api/v0/vendors/#{invalid_id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
      end

      it 'cannot get a vendor with invalid params during sad path' do
        vendor_params = ({
          name: 'Yang Express',
          description: 'Premier Chinese Takeout',
          contact_name: '',
          contact_phone: '2135702926',
          credit_accepted: true
        })

        id = create(:vendor).id
      
        headers = {"CONTENT_TYPE" => "application/json"}
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        
        data = JSON.parse(response.body, symbolize_names: true)
  
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first).to eq("Contact name can't be blank")
      end
    end

    describe "Can delete a Vendor /api/v0/vendors/:id path" do
      it "can destroy a vendor" do
        vendor = create(:vendor)
  
        expect(Vendor.count).to eq(1)
  
        delete "/api/v0/vendors/#{vendor.id}"
  
        expect(response).to be_successful
        expect(Vendor.count).to eq(0)
        expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'cannot delete a vendor with invalid id during sad path' do
        invalid_id = 123123123
        vendor_params = { contact_name: 'Invalid Vendor', credit_accepted: false }
        headers = {"CONTENT_TYPE" => "application/json"}
        
        delete "/api/v0/vendors/#{invalid_id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
      end
    end
  end
end