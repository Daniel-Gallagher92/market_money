require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  describe "GET /index" do
    it "returns all of the markets" do
      create_list(:market, 10)

      get "/api/v0/markets"

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets.count).to eq(10)
      expect(markets.first.keys).to eq([:id, :name, :street, :city, :county, :state, :zip, :lat, :lon])

      markets.each do |market|
        expect(market).to be_a(Hash)

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(Integer)

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)

        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)

        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)

        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_a(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_a(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_a(String)

        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_a(String)
      end
    end
  end

  describe "can return a single market by id" do 
    it "happy path" do
      create_list(:market, 4)

      get "/api/v0/markets/#{Market.first.id}"

      expect(response).to be_successful
    end

    # it "sad path" do
    #   get "/api/v0/markets/1000000"

    #   data = JSON.parse(response.body, symbolize_names: true)
      
    #   expect(response.status).to eq(404)
    # end
  end
end