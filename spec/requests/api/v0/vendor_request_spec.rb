require 'rails_helper'

RSpec.describe 'Vendor API', type: :request do
  describe 'GET /api/v0/vendors/:id' do 
    it 'returns a vendor if valid vendor id is passed in' do 
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to have_http_status(200)

      vendor_response = JSON.parse(response.body, symbolize_names: true)
      data = vendor_response[:data]

      expect(data[:id]).to be_a(String)
      expect(data[:type]).to eq('vendor')
      expect(data[:attributes]).to be_a(Hash)
      expect(data[:attributes][:name]).to be_a(String)
      expect(data[:attributes][:description]).to be_a(String)
      expect(data[:attributes][:contact_name]).to be_a(String)
      expect(data[:attributes][:contact_phone]).to be_a(String)
      expect(data[:attributes][:credit_accepted]).to be_in([true, false])
    end

    it 'returns a 404 if invalid vendor id is passed in' do 
      get "/api/v0/vendors/9021000000"

      expect(response).to have_http_status(404)
      
      nope = JSON.parse(response.body, symbolize_names: true)

      expect(nope).to have_key(:errors)
      expect(nope[:errors]).to be_an(Array)
      expect(nope[:errors].first).to have_key(:details)
      expect(nope[:errors].first[:details]).to eq("Couldn't find Vendor with 'id'=9021000000")
    end
  end
end