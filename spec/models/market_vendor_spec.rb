require 'rails_helper'

RSpec.describe MarketVendor, type: :model do

  describe 'relationships' do
    it { should belong_to :market }
    it { should belong_to :vendor }
  end

  describe 'validations' do
    it { should validate_presence_of :market_id }
    it { should validate_presence_of :vendor_id }
  end

  describe 'custom validations' do
    it 'should not allow duplicate market vendors' do 
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
      invalid_market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)

      expect(invalid_market_vendor).to_not be_valid
    end
  end
end