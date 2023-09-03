class Atm
  attr_reader :name, :address, :id, :distance, :lat, :lon

  def initialize(data)
    @id = nil
    @name = data[:poi][:name]
    @address = data[:address][:freeformAddress]
    @distance = data[:dist]
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
  end
end