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
      end
    end
  end
end