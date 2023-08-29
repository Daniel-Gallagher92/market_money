class Market < ApplicationRecord 
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates_presence_of :name,
                        :street,
                        :city,
                        :county,
                        :state,
                        :zip,
                        :lat,
                        :lon

  # before_save { |market| market.vendor_count = market.vendors.count }

  # def vendor_count
  #   vendors.count
  # end
end