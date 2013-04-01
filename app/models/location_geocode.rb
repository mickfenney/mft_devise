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
      result = Geocoder.search(address_input)
      result.each do |a|
        @address = a.formatted_address
        # a.geometry.each do |g|
        #   g.each do |l|
        #     @latitude = a.geometry
        #     #@longitude
        #   end 
        # end         
      end
    end
    if @address.nil?
      @address = address_input
    end
    if @latitude.nil?
      @latitude = nil
    end    
    return @address
  end

  def address()
    @address
  end   

  def latitude()
    @latitude
  end    

  def longitude()
    @longitude
  end   

end
