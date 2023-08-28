require 'rails_helper'

RSpec.describe Market, type: :model do

  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  # describe 'instance methods' do
  #   describe '#vendor_count' do
  #     market = Market.create(:market)

  #     create(:market_vendor, market => market)
  #     create(:market_vendor, market: market)

  #     expect(market.vendor_count).to eq(2)
  #   end
  # end
end