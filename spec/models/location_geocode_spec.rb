#require 'location_geocode'
require 'spec_helper'

describe LocationGeocode do

  describe "Class Instantiation with constructor parameter:" do

    before(:each) do
      @converter = LocationGeocode.new
    end

    it "should return the same address when given a valid google address" do
      @converter.address_encode('A New Address').should == 'A New Address'
      #@converter.city.should == 'Melbourne'

    end

    it "should return a repaired address when given a valid, but not complete address" do
      pending
      @converter.address_encode('A New Address').should == 'A New Address'
    end

  end

  describe "Class Instantiation with constructor parameter:" do

    before(:each) do
      @converter2 = LocationGeocode.new('Big Ben UK')
    end    

    it "should whatever..." do
      pending
      @converter2.city.should == 'London'
    end

  end

end
