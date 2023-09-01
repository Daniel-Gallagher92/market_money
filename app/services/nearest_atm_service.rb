class NearestAtmService 

  def self.conn 
    Faraday.new(url: 'https://api.tomtom.com/') do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom_api_key[:key]
    end
  end

  def self.nearest_atms(lat, lon) 
    response = conn.get do |req|
      req.url "search/2/nearbySearch/.json", lat: lat, lon: lon, categorySet: '7397'
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end