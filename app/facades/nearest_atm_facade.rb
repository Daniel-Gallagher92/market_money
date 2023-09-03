class NearestAtmFacade

  def self.nearest_atms(market)
    parsed = JSON.parse(NearestAtmService.nearest_atms(market).body, symbolize_names: true)
    atms = parsed[:results].map do |atm_data|
      Atm.new(atm_data)
    end
    atms.sort_by { |atm| atm.distance }
  end
end