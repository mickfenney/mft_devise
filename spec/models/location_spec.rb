require 'spec_helper'

describe Location do
################################################################################
  describe "Class Field Presence:" do
    it { should respond_to(:name) }
    it { should respond_to(:address) }
    it { should respond_to(:is_map) }
    it { should respond_to(:longitude) }
    it { should respond_to(:latitude) }
  end
################################################################################
  describe "Class Instantiation:" do

    before(:each) do
      @micks_house = FactoryGirl.build(:location)
    end

    it "should create a new instance given valid attributes" do
      location = FactoryGirl.build(:location, :address => nil)
      location.should_not be_valid
    end

    it "should populate the latitude field when given a valid address" do
      location = FactoryGirl.create(:location, :latitude => nil)
      location.latitude.should == @micks_house.latitude
    end

    it "should populate the longitude field when given a valid address" do
      location = FactoryGirl.create(:location, :longitude => nil)
      location.longitude.should == @micks_house.longitude
    end

    it "should not populate the latitude field when show google map is false" do
      location = FactoryGirl.create(:location, :latitude => nil, :is_map => false)
      location.latitude.should be_nil
    end

    it "should not populate the longitude field when no google map is false" do
      location = FactoryGirl.create(:location, :longitude => nil, :is_map => false)
      location.longitude.should be_nil
    end 
    
  end
################################################################################
end
