class NearestAtmService 

  def self.nearest_atms(market) 
    conn.get do |req|
      req.url "search/2/nearbySearch/.json"
      req.params[:lat] = market.lat
      req.params[:lon] = market.lon
      req.params[:radius] = 1000
      req.params['categorySet'] = 7397
    end
  end
  
  def self.conn 
    Faraday.new(url: 'https://api.tomtom.com/') do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom_api_key[:key]
    end
  end
end