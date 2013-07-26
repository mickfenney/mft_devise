require 'spec_helper'

describe Document do

  it { should respond_to(:title) }
  it { should respond_to(:document_type_id) }
  it { should respond_to(:body) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :title }
  it { should_not strip_attribute :document_type_id }
  it { should strip_attribute :body }
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      #FactoryGirl.create(:document_type)
      doc = FactoryGirl.create(:document)
      doc.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do
    it 'should reject a title that is too long' do
      d = FactoryGirl.build(:document, :title => Array.new(256, "a").join)
      d.should_not be_valid
    end

    it 'should not accept a blank title' do
      d = FactoryGirl.build(:document, :title => '')
      d.should_not be_valid
    end

    # it "should not create a new instance given an invalid 'doc type' attribute" do
    #   d = FactoryGirl.build(:document, :document_type_id => 'invalid')
    #   d.should_not be_valid
    # end    

    it "should not create a new instance given a nil 'doc type' attribute" do
      d = FactoryGirl.build(:document, :document_type_id => nil)
      d.should_not be_valid
    end

    it "should accept valid doc type" do
      FactoryGirl.create(:document_type)
      d = FactoryGirl.build(:document)
      d.should be_valid
    end  

    it 'should reject a body that is too long' do
      d = FactoryGirl.build(:document, :body => Array.new(50001, "a").join)
      d.should_not be_valid
    end

    it 'should not accept a blank body' do
      d = FactoryGirl.build(:document, :body => '')
      d.should_not be_valid
    end   

    it "should accept valid user id" do
      FactoryGirl.create(:document_type)
      d = FactoryGirl.build(:document)
      d.should be_valid
    end  

    it 'should not accept a blank user id' do
      d = FactoryGirl.build(:document, :user_id => '')
      d.should_not be_valid
    end       

  end
end
