require 'rails_helper'

RSpec.describe NearestAtmFacade do 

  it "returns the nearest atms to a given location via tomtom api", :vcr do 
    market = create(:market, lat: 35.07904, lon: -106.60068)

    atms = NearestAtmFacade.nearest_atms(market)
    expect(atms).to be_an(Array)
    expect(atms.first).to be_a(Atm)
    expect(atms.last).to be_a(Atm)
  end
  # it 'returns the nearest atms to a given location via tomtom api', :vcr do
  #   market = create(:market, lat: 35.07904, lon: -106.60068)
  #   facade = NearestAtmFacade.new
  #   response = facade.nearest_atms(market)

  #   expect(response).to be_an(Array)
  #   expect(response.first).to be_a(NearestAtm)
  #   expect(response.first.name).to eq('ATM')
  #   expect(response.first.address).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
  # end
end