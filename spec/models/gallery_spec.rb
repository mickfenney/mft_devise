# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Gallery do

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :name }
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      g = FactoryGirl.create(:gallery)
      g.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it 'should reject a name that is too long' do
      g = FactoryGirl.build(:gallery, :name => Array.new(256, "a").join)
      g.should_not be_valid
    end

    it 'should not accept a blank name' do
      g = FactoryGirl.build(:gallery, :name => '')
      g.should_not be_valid
    end  

    it "should not create a new instance given a nil 'name' attribute" do
      g = FactoryGirl.build(:gallery, :name => nil)
      g.should_not be_valid
    end

    it "should reject duplicate names" do
      g = FactoryGirl.create(:gallery, :name =>  'gallery1')
      g = FactoryGirl.build(:gallery, :name =>  'gallery1')
      g.should_not be_valid
    end              

    it "should accept valid user id" do
      g = FactoryGirl.build(:gallery)
      g.should be_valid
    end  

    it 'should not accept a blank user id' do
      g = FactoryGirl.build(:gallery, :user_id => '')
      g.should_not be_valid
    end       

  end
end
