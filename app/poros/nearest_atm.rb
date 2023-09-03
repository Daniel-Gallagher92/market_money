class NearestAtm
  attr_reader :name, :address, :id, :distance, :lat, :lon

  def initialize(attributes)
    @id = nil
    @name = attributes[:name]
    @address = attributes[:address]
    @distance = attributes[:distance]
    @lat = attributes[:lat]
    @lon = attributes[:lon]
  end
end