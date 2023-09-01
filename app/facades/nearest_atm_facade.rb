class NearestAtmFacade

  def self.nearest_atm(market)

    service = NearestAtmService.new
    raw_atms = service.nearest_atms(market)[:results]
    raw_atms.map do |raw_atm|
      NearestAtm.new(raw_atm)
    end
  end

  # def nearest_atm
  #   @nearest_atm ||= NearestAtmService.new(@location).nearest_atm
  # end
end