require 'rails_helper'

RSpec.describe NearestAtmFacade do 

  it "returns the nearest atms to a given location via tomtom api", :vcr do 
    market = create(:market, lat: 35.07904, lon: -106.60068)

    atms = NearestAtmFacade.nearest_atms(market)
    expect(atms).to be_an(Array)
    expect(atms.first).to be_a(Atm)
    expect(atms.last).to be_a(Atm)

    atms.each_cons(2) do |atm1, atm2|
      expect(atm1.distance < atm2.distance).to be(true)
    end
  end
end