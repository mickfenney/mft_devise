# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  address        :string(255)
#  is_map         :boolean          default(TRUE)
#  latitude       :float
#  longitude      :float
#  locatable_id   :integer
#  locatable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Location do
################################################################################
describe "Class Field Presence:" do
  it { should respond_to(:name) }
  it { should respond_to(:address) }
  it { should respond_to(:is_map) }
  it { should respond_to(:longitude) }
  it { should respond_to(:latitude) }

  it { should strip_attribute :name }
  it { should_not strip_attribute :address }
  it { should_not strip_attribute :is_map } 
  it { should_not strip_attribute :longitude }
  it { should_not strip_attribute :latitude } 
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

    it "should not populate the longitude field when show google map is false" do
      location = FactoryGirl.create(:location, :longitude => nil, :is_map => false)
      location.longitude.should be_nil
    end 

    it "should store full address when given a partial but valid address" do
      raw_address = 'Big Ben UK'
      wanted_address = 'Big Ben, City of Westminster, London SW1A, UK'
      location = FactoryGirl.create(:location, :address => raw_address)
      Location.first.address.should == wanted_address
    end

    it "should store the correct latitude when given a partial but valid address" do
      location = FactoryGirl.create(:location, :address => @micks_house.address, :latitude => nil)
      Location.first.latitude.should == @micks_house.latitude
    end

    it "should store the correct longitude when given a partial but valid address" do
      location = FactoryGirl.create(:location, :address => @micks_house.address, :longitude => nil)
      Location.first.longitude.should == @micks_house.longitude
    end        

    it "should reset the address, latitude and longitude fields to nil when updating an existing record with an invalid address" do
      invalid_address = 'Not a valid address'
      # insert mick factory into db (valid)
      FactoryGirl.create(:location, :latitude => nil, :longitude => nil)
      # update mick record to be invalid
      mick = Location.first
      mick.address = invalid_address
      mick.save
      # Make sure the database record count stays at 1
      Location.count.should == 1
      # query back mick record and check fileds are nil
      mick_updated = Location.first
      mick_updated.address.should == invalid_address
      mick_updated.latitude.should be_nil
      mick_updated.longitude.should be_nil
      mick_updated.is_map.should be_false
    end 
    
  end
################################################################################
end
