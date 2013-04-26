require 'spec_helper'

describe EmailMessagePresenter do
################################################################################
describe "Class Field Presence:" do
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:content) }
end
################################################################################
  describe "Class Instantiation:" do

    it "should not create a new instance given nil name attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :name => nil)
      email_message.should_not be_valid
    end

    it "should create a new instance given valid name attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :name => 'Valid Name')
      email_message.should be_valid
    end

    it "should not create a new instance given nil email attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :email => nil)
      email_message.should_not be_valid
    end

    it "should not create a new instance given invalid email attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :email => 'abc')
      email_message.should_not be_valid
    end    

    it "should not create a new instance given valid email attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :email => 'from@example.com')
      email_message.should be_valid
    end    

    it "should create a new instance given nil content attribute" do
      email_message = FactoryGirl.build(:email_message_presenter, :content => nil)
      email_message.should be_valid
    end   

    it "should not create a new instance given content attribute more than 500 characters" do
      email_message = FactoryGirl.build(:email_message_presenter, :content => Array.new(501, "a").join)
      email_message.should_not be_valid
    end      

  end
################################################################################
end
