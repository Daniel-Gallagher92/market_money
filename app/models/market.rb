class Market < ApplicationRecord 
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  # before_save { |market| market.vendor_count = market.vendors.count }

  # def vendor_count
  #   vendors.count
  # end
end