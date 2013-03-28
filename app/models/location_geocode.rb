require 'geocoder'

class LocationGeocode

  def initialize(address_input = nil)
    unless address_input.nil?
      @address = address_input
      address_encode(@address)
    end
  end

  def address_encode(address_input = @address)
    unless address_input.nil?
      @result = Geocoder.search(address_input)
      @result.each do |a|
        return @address = a.formatted_address
      end
    end
  end

  def latitude_encode()
    @result = Geocoder.search(@address)
    unless @result.nil?
      @result.each do |a|
        a.geometry.each do |g|
          return @latitude = g
        end  
      end
    end
  end  

end
