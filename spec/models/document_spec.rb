require 'spec_helper'

describe Document do

  it { should respond_to(:title) }
  it { should respond_to(:doc_type) }
  it { should respond_to(:body) }

  it { should strip_attribute :title }
  it { should strip_attribute :doc_type }
  it { should strip_attribute :body }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
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
      d = FactoryGirl.build(:document, :title => Array.new(50001, "a").join)
      d.should_not be_valid
    end

    it 'should not accept a blank body' do
      d = FactoryGirl.build(:document, :title => '')
      d.should_not be_valid
    end    

  end
end
