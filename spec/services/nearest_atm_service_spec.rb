require 'rails_helper'

RSpec.describe NearestAtmService do
  describe 'class methods' do 
    describe 'nearest_atms' do
      it 'returns the nearest atms to a given location via tomtom api', :vcr do
        market = create(:market)
        response = NearestAtmService.nearest_atms(market.lat, market.lon)

        expect(response).to be_a(Hash)
        expect(response[:results]).to be_an(Array)
        binding.pry
      end
    end
  end
end