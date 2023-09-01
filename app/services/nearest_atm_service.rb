class NearestAtmService 

  def self.nearest_atms(market) 
    response = conn.get do |req|
      req.url "search/2/nearbySearch/.json",lat: market.lat, lon: market.lon
      req.params['categorySet'] = 7397
    end
    JSON.parse(response.body, symbolize_names: true)
    require "pry"; binding.pry
  end

  # def self.get_url(url) 
  #   response = conn.get(url)
  #   JSON.parse(response.body, symbolize_names: true)
  # end

  def self.conn 
    Faraday.new(url: 'https://api.tomtom.com/') do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom_api_key[:key]
    end
  end
end