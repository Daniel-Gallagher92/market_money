require 'rails_helper'

RSpec.describe Market, type: :model do

  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end
  
  describe 'class methods' do
    it 'can search by all valid criteria combinations (city, state, name)' do
      cfl_markets = create_list(:market, 3, city: "Orlando", state: "Florida")
      co_markets = create_list(:market, 4, state: "Colorado")
      nyc_markets = create_list(:market, 5, city: "New York City", state: "New York")

      params = ({state: "Florida", city: cfl_markets.first.city, name: cfl_markets.first.name})
      expect(Market.search(params)).to eq([cfl_markets.first])

      more_params = ({state: "Colorado", name: co_markets.first.name})
      expect(Market.search(more_params)).to eq([co_markets.first])

      butwaittheres_more = ({state: "New York"})
      expect(Market.search(butwaittheres_more)).to eq(nyc_markets)
    end

    it 'cannot search city without state' do
      market = create(:market)

      params = ({city: market.city, name: market.name})
      expect(Market.search(params)).to be_a(ErrorMarket)
    end

    it 'cannot search with empty search params' do
      market = create(:market, state: "Florida")
      params = ({state: "", city: "", name: ""})
      expect(Market.search(params)).to be_a(ErrorMarket)
      expect(Market.search(params).error_message).to eq("Please provide valid search parameters. Example: State; State and City; State, City and Name; State and Name, or Name.")
    end

    it 'can return results on partial search params' do
      market = create(:market, state: "Florida", city: "Orlando", name: "Winter Park Farmers Market")
      params = ({state: "Flo", city: "Orla", name: "Winter Park"})

      expect(Market.search(params)).to eq([market])
    end

    it 'checks if search params are empty' do
      params = ({state: "", city: "", name: ""})

      expect(Market.empty_search?(params)).to eq(true)
    end
  end
end