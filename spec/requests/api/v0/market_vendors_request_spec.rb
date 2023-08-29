require 'rails_helper'

RSpec.describe "Vendor API", type: :request do 
  describe 'GET /markets/:id/vendors' do
    it 'gets all vendors for market - happy path' do
      market_1 = create(:market)
      market_2 = create(:market)

      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)

      create(:market_vendor, market_id: market_1.id, vendor_id: vendor_1.id)
      create(:market_vendor, market_id: market_1.id, vendor_id: vendor_2.id)

      get "/api/v0/markets/#{market_1.id}/vendors"

      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:data].count).to eq(2)

      vendors = data[:data]

      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor).to have_key(:type)

        vendor_attributes = vendor[:attributes]

        expect(vendor_attributes).to have_key(:name)
        expect(vendor_attributes).to have_key(:description)
        expect(vendor_attributes).to have_key(:contact_name)
        expect(vendor_attributes).to have_key(:contact_phone)
        expect(vendor_attributes).to have_key(:credit_accepted)
        expect(vendor_attributes[:credit_accepted]).to be_in([true, false])
      end

      vendor = vendors.first
      attributes = vendor[:attributes]

      expect(attributes[:name]).to eq(vendor_1.name)
      expect(attributes[:description]).to eq(vendor_1.description)
      expect(attributes[:contact_name]).to eq(vendor_1.contact_name)
      expect(attributes[:contact_phone]).to eq(vendor_1.contact_phone)
      expect(attributes[:credit_accepted]).to eq(vendor_1.credit_accepted)
    end

    it 'sad path' do

      get "/api/v0/markets/123123123123/vendors"

      expect(response.status).to eq(404)
      nope = JSON.parse(response.body, symbolize_names: true)

      expect(nope).to have_key(:errors)
      expect(nope[:errors].first[:details]).to be_a(String)
      expect(nope[:errors].first[:details]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end