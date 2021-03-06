require 'spec_helper'

describe LocationGeocodeService do

  describe "Class Instantiation without Constructor Parameter:" do

    before(:each) do
      @converter = LocationGeocodeService.new
    end
    
    describe "#new" do
        it "no parameters and returns a LocationGeocodeService object" do
            @converter.should be_an_instance_of LocationGeocodeService
        end
    end       

    it "should return the full address when given a valid google address", :vcr do
      @converter.address = 'Big Ben UK'
      @converter.address.should == 'Big Ben, Westminster, London SW1A 0AA, UK' 
      @converter.latitude.should == 51.5007282
      @converter.longitude.should == -0.1246263
    end     

    it "should return the passed in address when given a non valid address", :vcr do
      @converter.address = 'Not a valid address'
      @converter.address.should == 'Not a valid address'
    end

    it "should return no address when given a noaddress_encode address" do
      @converter.address = nil
      @converter.address.should == nil
    end

  end

  ################################################################################

  describe "Class Instantiation with Constructor Parameter:" do

    before(:each) do
      @converter2 = LocationGeocodeService.new('Big Ben UK')
    end  

    describe "#new" do
        it "returns a LocationGeocodeService object with google full address", :vcr do
            @converter2.should be_an_instance_of LocationGeocodeService
        end
    end        

    it "should return the full address when given a valid google address in the constructor parameter", :vcr do
      @converter2.address.should == 'Big Ben, Westminster, London SW1A 0AA, UK' 
    end  

    #####

    before(:each) do
      @converter3 = LocationGeocodeService.new('Not a valid address')
    end  

    describe "#new" do
        it "returns a LocationGeocodeService object with passed in address", :vcr do
            @converter3.should be_an_instance_of LocationGeocodeService
        end
    end       

    it "should return the passed in address when given a non valid address in the constructor parameter", :vcr do
      @converter3.address.should == 'Not a valid address'
    end           

  end

end
