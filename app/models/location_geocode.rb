require 'geocoder'

class LocationGeocode 

  # Create on the fly getters for these data members
  attr_reader :address, :latitude, :longitude

  # Create on the fly setters for these data members
  #attr_writer :address

  def address=(address_input = nil)
    unless address_input.nil?
      @address = address_input
      address_encode(@address)
    end
  end

  # Create on the fly setters for these data members
  #attr_accessor :address

  def initialize(address_input = nil)
    unless address_input.nil?
      @address = address_input
      address_encode(@address)
    end
  end

  protected

    def address_encode(address_input = @address)
      @address   = address_input
      @latitude  = nil
      @longitude = nil
      unless address_input.nil?
        # if `hostname`.strip.downcase.match(/^rav/)
        #   Geocoder.configure(:http_proxy => 'fenneym:xxxxxx@equwsgateway.salmat.com.au:8080', :timeout => 5)
        # end
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
      #return @address
    end

end
