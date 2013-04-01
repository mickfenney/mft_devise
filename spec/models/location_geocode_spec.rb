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

    it "should return the address method full address when given a valid google address" do
      @converter.address_encode('Big Ben UK')
      @converter.address.should == 'Big Ben, Westminster Bridge Road, Parliament Square, London, Greater London SW1A 0AA, UK' 
      #@converter.latitude.should == '51.5007046' 
      #@converter.longitude.should == '-0.1245748'
    end     

    it "should return the passed in address when given a non valid address" do
      @converter.address_encode('Not a valid address').should == 'Not a valid address'
    end

    it "should return the adress method passed in address when given a non valid address" do
      @converter.address_encode('Not a valid address')
      @converter.address.should == 'Not a valid address'
    end    

    it "should return no address when given a no address" do
      @converter.address_encode().should == nil
    end

  end

  ################################################################################

  describe "Class Instantiation with Constructor Parameter:" do

    before(:each) do
      @converter2 = LocationGeocode.new('Big Ben UK')
    end    

    it "should return the full address when given a valid google address in the constructor parameter" do
      @converter2.address_encode().should == 'Big Ben, Westminster Bridge Road, Parliament Square, London, Greater London SW1A 0AA, UK' 
    end  

    it "should return the address method full address when given a valid google address in the constructor parameter" do
      @converter2.address.should == 'Big Ben, Westminster Bridge Road, Parliament Square, London, Greater London SW1A 0AA, UK' 
    end     

    before(:each) do
      @converter3 = LocationGeocode.new('Not a valid address')
    end    

    it "should return the passed in address when given a non valid address in the constructor parameter" do
      @converter3.address_encode().should == 'Not a valid address'
    end  

    it "should return the address method passed in address when given a non valid address in the constructor parameter" do
      @converter3.address.should == 'Not a valid address'
    end          

  end

end
