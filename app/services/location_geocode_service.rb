require 'geocoder'

class LocationGeocodeService 

  # Create on the fly getters for these data members
  attr_reader :address, :latitude, :longitude, :geocoder_result

  # Create on the fly setters for these data members
  #attr_writer :address, :latitude, :longitude

  def address=(address_input = nil)
    unless address_input.nil?
      @address = address_input
      convert(@address)
    end
  end

  # Create on the fly getters and setters for these data members
  #attr_accessor :address, :latitude, :longitude

  def initialize(address_input = nil)
    unless address_input.nil?
      @address = address_input
      convert(@address)
    end
  end

  protected

    def convert(address_input = @address)
      @address   = address_input
      @latitude  = nil
      @longitude = nil
      unless @address.nil?
        @address.strip!
        unless ENV['HTTP_PROXY'].nil?
          http_proxy_env = ENV['HTTP_PROXY'].sub(/http:\/\//, "")
          Geocoder.configure(:http_proxy => http_proxy_env, :timeout => 5)
        end          
        @geocoder_result = Geocoder.search(@address)
        begin
          @geocoder_result.each do |a|
            @address = a.formatted_address.strip
            a.geometry.each do |key, value|
              if key.eql?('location')
                @latitude = value['lat']
                @longitude = value['lng']
                break
              end 
            end         
          end
        rescue Exception
          # sending back nil  
        end
      end     
    end

end
