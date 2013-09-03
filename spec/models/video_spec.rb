require 'spec_helper'

describe Video do

  it { should respond_to(:name) }
  it { should respond_to(:code) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :name }
  it { should strip_attribute :code }
  it { should strip_attribute :description }
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      v = FactoryGirl.create(:video)
      v.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it 'should reject a name that is too long' do
      v = FactoryGirl.build(:video, :name => Array.new(256, "a").join)
      v.should_not be_valid
    end

    it 'should not accept a blank name' do
      v = FactoryGirl.build(:video, :name => '')
      v.should_not be_valid
    end  

    it "should not create a new instance given a nil 'name' attribute" do
      v = FactoryGirl.build(:video, :name => nil)
      v.should_not be_valid
    end

    it "should reject duplicate names" do
      v = FactoryGirl.create(:video, :name =>  'video1')
      v = FactoryGirl.build(:video, :name =>  'video1')
      v.should_not be_valid
    end    

    it 'should reject a code that is too long' do
      v = FactoryGirl.build(:video, :code => Array.new(51, "a").join)
      v.should_not be_valid
    end

    it 'should not accept a blank code' do
      v = FactoryGirl.build(:video, :code => '')
      v.should_not be_valid
    end  

    it "should not create a new instance given a nil 'code' attribute" do
      v = FactoryGirl.build(:video, :code => nil)
      v.should_not be_valid
    end

    it "should reject duplicate codes" do
      v = FactoryGirl.create(:video, :code =>  'code1')
      v = FactoryGirl.build(:video, :code =>  'code1')
      v.should_not be_valid
    end           

    it 'should reject a description that is too long' do
      v = FactoryGirl.build(:video, :description => Array.new(401, "a").join)
      v.should_not be_valid
    end

    it 'should not accept a blank description' do
      v = FactoryGirl.build(:video, :description => '')
      v.should_not be_valid
    end  

    it "should not create a new instance given a nil 'description' attribute" do
      v = FactoryGirl.build(:video, :description => nil)
      v.should_not be_valid
    end     

    it "should accept valid user id" do
      v = FactoryGirl.build(:video)
      v.should be_valid
    end  

    it 'should not accept a blank user id' do
      v = FactoryGirl.build(:video, :user_id => '')
      v.should_not be_valid
    end       

  end
end