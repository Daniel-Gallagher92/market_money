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

  describe "POST /api/v0/market_vendors" do
    it "can create a new market_vendor with both valid id's" do 
      market_1 = create(:market)
      vendor_1 = create(:vendor)

      market_vendor_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })

      headers = { "CONTENT_TYPE" => "application/json" }
      
      expect(MarketVendor.exists?).to eq(false)

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to have_http_status(201)
      expect(MarketVendor.exists?).to eq(true)

      # get "/api/v0/markets/#{market_1.id}/vendors" #when I uncomment this line, the test fails. Why?
      
      # expect(response.status).to eq(200)

      new_market_vendor = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(new_market_vendor[:attributes]).to have_key(:market_id)
      expect(new_market_vendor[:attributes][:market_id]).to eq(market_1.id)
      
      expect(new_market_vendor[:attributes]).to have_key(:vendor_id)
      expect(new_market_vendor[:attributes][:vendor_id]).to eq(vendor_1.id)
    end

    it 'returns a 404 if invalid market id is passed in' do 
      vendor_1 = create(:vendor)

      market_vendor_params = ({
        market_id: 123456543,
        vendor_id: vendor_1.id
      }) 

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to have_http_status(404)
      
      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first[:details]

      expect(nope).to eq("Validation failed: Market must exist")
    end

    it 'returns a 404 if invalid vendor id is passed in' do 
      market = create(:market)

      market_vendor_params = ({
        market_id: market.id,
        vendor_id: 123456543
      })

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to have_http_status(404)

      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first[:details]

      expect(nope).to eq("Validation failed: Vendor must exist")
    end

    it 'returns a 400 if no market/vendor params are passed in' do
      params = { }

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(response).to have_http_status(400)

      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first[:details]

      expect(nope).to eq("param is missing or the value is empty: market_vendor")
    end

    it "returns 422 when trying to create a market_vendor that already exists" do 
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

      params = { market_id: market.id, vendor_id: vendor.id }
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(response).to have_http_status(422)
      
      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first[:details]
      
      expect(nope).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end

  describe "DELETE /api/v0/market_vendors" do 
    before :each do
      @market = create(:market)
      @vendor = create(:vendor)
      @market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    end

    it '204, can delete a market_vendor with valid id' do
      params = { market_id: @market.id, vendor_id: @vendor.id }
      headers = { "CONTENT_TYPE" => "application/json" }
      
      expect(MarketVendor.exists?(params)).to eq(true)

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(MarketVendor.exists?(params)).to eq(false)
      expect(response).to have_http_status(204)
      expect(response.body).to eq("")
    end

    it 'returns 404 if invalid id passed in' do 
      market_id = 12345676543
      vendor_id = 19876789032 
      params = { market_id: market_id, vendor_id: vendor_id }
      headers = { "CONTENT_TYPE" => "application/json" }

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(response).to have_http_status(404)

      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first[:details]

      expect(nope).to eq("Couldn't find MarketVendor with market_id=#{market_id} and vendor_id=#{vendor_id}")
    end
  end
end