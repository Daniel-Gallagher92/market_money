class NearestAtm
  def initialize(raw_atm)
    require 'pry'; binding.pry
    @name = raw_atm[:name]
  end
end