require 'spec_helper'

describe DocumentType do

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :name }
  it { should strip_attribute :description }
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      dt = FactoryGirl.create(:document_type)
      dt.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it 'should reject a name that is too long' do
      dt = FactoryGirl.build(:document_type, :name => Array.new(256, "a").join)
      dt.should_not be_valid
    end

    it 'should not accept a blank name' do
      dt = FactoryGirl.build(:document_type, :name => '')
      dt.should_not be_valid
    end  

    it "should not create a new instance given a nil 'name' attribute" do
      dt = FactoryGirl.build(:document_type, :name => nil)
      dt.should_not be_valid
    end

    it "should reject duplicate names" do
      dt = FactoryGirl.create(:document_type, :name =>  'ruby')
      dt = FactoryGirl.build(:document_type, :name =>  'ruby')
      dt.should_not be_valid
    end          

    it 'should reject a description that is too long' do
      dt = FactoryGirl.build(:document_type, :description => Array.new(256, "a").join)
      dt.should_not be_valid
    end

    it 'should not accept a blank description' do
      dt = FactoryGirl.build(:document_type, :description => '')
      dt.should_not be_valid
    end  

    it "should not create a new instance given a nil 'description' attribute" do
      dt = FactoryGirl.build(:document_type, :description => nil)
      dt.should_not be_valid
    end     

    it "should accept valid user id" do
      dt = FactoryGirl.build(:document_type)
      dt.should be_valid
    end  

    it 'should not accept a blank user id' do
      dt = FactoryGirl.build(:document_type, :user_id => '')
      dt.should_not be_valid
    end       

  end
end
