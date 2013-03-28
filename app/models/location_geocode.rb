require 'geocoder'

class LocationGeocode

  def initialize(address_input = nil)
    unless address_input.nil?
      @address = address_input
      address_encode(@address)
    end
  end

  def address_encode(address_input = @address)

    # test west we have something to do

    #result = Geocoder.search(address)

    #@city = result.city

    return address_input

  end

end
