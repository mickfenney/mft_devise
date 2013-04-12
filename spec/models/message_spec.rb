require 'spec_helper'

describe Message do
################################################################################
describe "Class Field Presence:" do
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:content) }
end
################################################################################
  describe "Class Instantiation:" do

    it "should not create a new instance given nil name attribute" do
      message = FactoryGirl.build(:message, :name => nil)
      message.should_not be_valid
    end

    it "should create a new instance given valid name attribute" do
      message = FactoryGirl.build(:message, :name => 'Valid Name')
      message.should be_valid
    end

    it "should not create a new instance given nil email attribute" do
      message = FactoryGirl.build(:message, :email => nil)
      message.should_not be_valid
    end

    it "should not create a new instance given invalid email attribute" do
      message = FactoryGirl.build(:message, :email => 'abc')
      message.should_not be_valid
    end    

    it "should not create a new instance given valid email attribute" do
      message = FactoryGirl.build(:message, :email => 'from@example.com')
      message.should be_valid
    end    

    it "should create a new instance given nil content attribute" do
      message = FactoryGirl.build(:message, :content => nil)
      message.should be_valid
    end   

    it "should not create a new instance given content attribute more than 500 characters" do
      message = FactoryGirl.build(:message, :content => Array.new(51, "abcdefghij").join)
      message.should_not be_valid
    end      

  end
################################################################################
end
