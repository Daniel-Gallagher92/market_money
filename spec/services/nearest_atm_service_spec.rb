require 'rails_helper'

RSpec.describe NearestAtmService do
  describe 'class methods' do 
    describe 'nearest_atms' do
      it 'returns the nearest atms to a given location via tomtom api', :vcr do
        market = create(:market, lat: 35.07904, lon: -106.60068)
        response = NearestAtmService.nearest_atms(market)
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(response.body).to_not be_nil
        expect(parsed).to be_a(Hash)
        expect(parsed[:results]).to be_an(Array)
        expect(parsed[:results][0][:poi][:name]).to eq('ATM')

        # expect(response[:results]).to be_an(Array)
        # expect(response[:results].first).to be_a(Hash)
        # expect(response[:results].first).to have_key(:poi)
        # expect(response[:results].first[:poi]).to be_a(Hash)
        # expect(response[:results].first[:poi][:categorySet].first).to have_key(:id)
        # expect(response[:results].first[:poi][:categorySet].first[:id]).to eq(7397)
        # expect(response[:results][0][:poi][:name]).to eq('ATM')
        # expect(response[:results][0][:address]).to be_a(Hash)
        # expect(response[:results][0][:address][:freeformAddress]).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
      end
    end
  end
end