require 'spec_helper'

describe Document do

  it { should respond_to(:title) }
  it { should respond_to(:doc_type) }
  it { should respond_to(:body) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :title }
  it { should strip_attribute :doc_type }
  it { should strip_attribute :body }
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      dt = FactoryGirl.create(:document_type)
      dt.should be_valid
      doc = FactoryGirl.create(:document, :doc_type => dt.name)
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

    it "should not create a new instance given an invalid 'doc type' (enum) attribute" do
      d = FactoryGirl.build(:document, :doc_type => 'notdoctype')
      d.should_not be_valid
    end    

    it "should not create a new instance given a nil 'doc type' (enum) attribute" do
      d = FactoryGirl.build(:document, :doc_type => nil)
      d.should_not be_valid
    end

    it "should accept valid doc type" do
      d = FactoryGirl.build(:document, :doc_type => 'text')
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
      d = FactoryGirl.build(:document, :user_id => 1)
      d.should be_valid
    end  

    it 'should not accept a blank user id' do
      d = FactoryGirl.build(:document, :user_id => '')
      d.should_not be_valid
    end       

  end
end
