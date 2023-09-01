class NearestAtmFacade
  def self.nearest_atms(lat, lon)
    NearestAtmService.find_nearest_atms(lat, lon)[:results].map do |atm_data|
      NearestAtm.new(atm_data)
    end
  end
end