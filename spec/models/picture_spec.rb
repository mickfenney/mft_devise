require 'spec_helper'

describe Picture do

  it { should respond_to(:name) }
  it { should respond_to(:image) }
  it { should respond_to(:remote_image_url) }
  it { should respond_to(:gallery_id) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :name }
  #it { should strip_attribute :image }
  #it { should strip_attribute :remote_image_url }
  it { should_not strip_attribute :gallery_id }  
  it { should_not strip_attribute :user_id }


################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      p = FactoryGirl.create(:picture)
      p.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it 'should reject a name that is too long' do
      p = FactoryGirl.build(:picture, :name => Array.new(256, "a").join)
      p.should_not be_valid
    end

    it 'should not accept a blank name' do
      p = FactoryGirl.build(:picture, :name => '')
      p.should be_valid
    end  

    it "should not create a new instance given a nil 'name' attribute" do
      p = FactoryGirl.build(:picture, :name => nil)
      p.should be_valid
    end           

    it "should accept valid user id" do
      p = FactoryGirl.build(:picture)
      p.should be_valid
    end  

    it 'should not accept a blank user id' do
      p = FactoryGirl.build(:picture, :user_id => '')
      p.should_not be_valid
    end       

  end
end
