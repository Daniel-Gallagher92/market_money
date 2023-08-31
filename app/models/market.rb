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

    def self.search(search_params) 
      queries = valid_search_queries(search_params)
      return queries if queries.class == ErrorMarket
      search_results = Market.all
      queries.each do |query| 
        search = query.to_s
        search_results = search_results.where("#{search} ILIKE ?", "%#{search_params[query]}%")
      end
      search_results
    end

    def self.valid_search_queries(search_params)
      if !search_params[:state].present? && search_params[:city].present?
        invalid_search_params
      elsif empty_search?(search_params)
        invalid_search_params
      else
        search_params.keys
      end
    end

    def self.invalid_search_params
      ErrorMarket.new("Please provide valid search parameters. Example: State; State and City; State, City and Name; State and Name, or Name.")
    end

    def self.empty_search?(search_params)
      search_params.values.any? { |value| value.empty? }
    end
end