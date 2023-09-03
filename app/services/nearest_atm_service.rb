class NearestAtmService 

  def self.nearest_atms(market) 
    response = conn.get do |req|
      req.url "search/2/nearbySearch/.json"
      req.params[:lat] = market.lat
      req.params[:lon] = market.lon
      req.params[:radius] = 1000
      req.params['categorySet'] = 7397
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_url(url) 
    @@url ||= response = conn.get(url) #Am I using this right?
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn 
    Faraday.new(url: 'https://api.tomtom.com/') do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom_api_key[:key]
    end
  end
end