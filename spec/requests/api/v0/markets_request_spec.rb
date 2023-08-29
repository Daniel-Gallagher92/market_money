require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  describe "GET /index" do
    it "returns all of the markets" do
      create_list(:market, 10)
      create_list(:vendor, 10)

      get "/api/v0/markets"

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)

      markets = data[:data]

      markets.each do |market|
        attributes = market[:attributes]

        expect(attributes).to have_key(:name)
        expect(market[:id]).to be_a(String)

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:street)
        expect(attributes[:street]).to be_a(String)

        expect(attributes).to have_key(:city)
        expect(attributes[:city]).to be_a(String)

        expect(attributes).to have_key(:county)
        expect(attributes[:county]).to be_a(String)

        expect(attributes).to have_key(:state)
        expect(attributes[:state]).to be_a(String)

        expect(attributes).to have_key(:zip)
        expect(attributes[:zip]).to be_a(String)

        expect(attributes).to have_key(:lat)
        expect(attributes[:lat]).to be_a(String)

        expect(attributes).to have_key(:lon)
        expect(attributes[:lon]).to be_a(String)

        expect(attributes).to have_key(:vendor_count)
        expect(attributes[:vendor_count]).to be_a(Integer)
      end
    end
  end

  describe "can return a single market by id" do 
    it "happy path" do
      create_list(:market, 4)

      get "/api/v0/markets/#{Market.first.id}"

      data = JSON.parse(response.body, symbolize_names: true)

      market = data[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes]).to have_key(:vendor_count)
    end

    it "sad path" do
      get "/api/v0/markets/1000000"
      
      expect(response.status).to eq(404)

      nope = JSON.parse(response.body, symbolize_names: true)
      expect(no_data).to have_key(:errors)
      expect(no_data[:errors]).to be_a(Array)

      expect(no_data[:errors][0]).to have_key(:details)
      expect(no_data[:errors][0][:details]).to be_a(String)
      expect(no_data[:errors][0][:details]).to eq("Couldn't find Market with 'id'=1000000")
    end
  end
end