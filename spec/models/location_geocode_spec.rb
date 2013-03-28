#require 'location_geocode'
#require 'geocoder'
require 'spec_helper'
describe LocationGeocode do

  describe "Class Instantiation without Constructor Parameter:" do

    before(:each) do
      @converter = LocationGeocode.new
    end

    describe "#new" do
        it "no parameters and returns a LocationGeocode object" do
            @converter.should be_an_instance_of LocationGeocode
        end
    end       

    it "should return the full address when given a valid google address" do
      @converter.address_encode('Big Ben UK').should == 'Big Ben, Westminster Bridge Road, Parliament Square, London, Greater London SW1A 0AA, UK'
    end

    it "should return the latitude when given a valid google address" do
      pending
      @converter.latitude_encode().should == '23525235'
    end    

    # it "should return a repaired address when given a valid, but not complete address" do
    #   pending
    #   @converter.address_encode('Big Ben UK').should == 'Westminster Bridge Rd, Parliament Square, London SW1A 0AA, United Kingdom'
    # end

  end

  # describe "Class Instantiation with Constructor Parameter:" do

  #   before(:each) do
  #     @converter2 = LocationGeocode.new('Big Ben UK')
  #   end    

  #   it "should whatever..." do
  #     pending
  #     @converter2.city.should == 'London'
  #   end

  # end

end
