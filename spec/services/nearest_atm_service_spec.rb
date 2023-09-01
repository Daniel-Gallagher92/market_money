require 'rails_helper'

RSpec.describe NearestAtmService do
  describe 'class methods' do 
    describe 'nearest_atms' do
      it 'returns the nearest atms to a given location via tomtom api', :vcr do
        market = create(:market)
        
        response = NearestAtmService.nearest_atms(market)

        expect(response).to be_a(Hash)
        expect(response[:results]).to be_an(Array)
      end
    end
  end
end