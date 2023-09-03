require 'rails_helper'

RSpec.describe Atm do
  it "converts hashes to objects", :vcr do
    response = File.read('spec/fixtures/atm_fixture_stub.json')
    
    parsed = JSON.parse(response, symbolize_names: true)
    atm = Atm.new(parsed)
    
    expect(atm).to be_a(Atm)
    expect(atm.name).to eq("ATM")
    expect(atm.address).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
    expect(atm.distance).to eq(0.445287)
    expect(atm.lat).to eq(35.079044)
    expect(atm.lon).to eq(-106.60068)
  end
end