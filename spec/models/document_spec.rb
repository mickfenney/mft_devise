# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_private :boolean          default(FALSE)
#

require 'spec_helper'

describe Document do

  it { should respond_to(:title) }
  it { should respond_to(:document_type_ids) }
  it { should respond_to(:body) }
  it { should respond_to(:user_id) }
  it { should respond_to(:is_private) }

  it { should strip_attribute :title }
  #it { should_not strip_attribute :document_type_ids }
  it { should strip_attribute :body }
  it { should_not strip_attribute :user_id }
  it { should_not strip_attribute :is_private }

################################################################################  
  before(:each) do
    @dt = FactoryGirl.create(:document_type)
  end  
################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      doc = FactoryGirl.create(:document, :document_type_ids => [@dt.id])
      doc.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do
    it 'should reject a title that is too long' do
      d = FactoryGirl.build(:document, :title => Array.new(256, "a").join, :document_type_ids => [@dt.id])
      d.should_not be_valid
    end

    it 'should not accept a blank title' do
      d = FactoryGirl.build(:document, :title => '', :document_type_ids => [@dt.id])
      d.should_not be_valid
    end

    # it "should not create a new instance given an invalid 'doc type' attribute" do
    #   d = FactoryGirl.build(:document, :document_type_ids => 0)
    #   d.should_not be_valid
    # end 

    it "should not create a new instance given a nil 'doc type' attribute" do
      d = FactoryGirl.build(:document, :document_type_ids => nil)
      d.should_not be_valid
    end

    it "should accept valid doc type" do
      d = FactoryGirl.build(:document, :document_type_ids => [@dt.id])
      d.should be_valid
    end  

    it 'should reject a body that is too long' do
      d = FactoryGirl.build(:document, :body => Array.new(50001, "a").join, :document_type_ids => [@dt.id])
      d.should_not be_valid
    end

    it 'should not accept a blank body' do
      d = FactoryGirl.build(:document, :body => '', :document_type_ids => [@dt.id])
      d.should_not be_valid
    end   

    it "should accept valid user id" do
      d = FactoryGirl.build(:document, :document_type_ids => [@dt.id])
      d.should be_valid
    end  

    it 'should not accept a blank user id' do
      d = FactoryGirl.build(:document, :user_id => '', :document_type_ids => [@dt.id])
      d.should_not be_valid
    end  

    it "should accept valid is private" do
      d = FactoryGirl.build(:document, :is_private => false, :document_type_ids => [@dt.id])
      d.should be_valid
    end  

    it 'should not accept a blank is private' do
      d = FactoryGirl.build(:document, :user_id => '', :document_type_ids => [@dt.id])
      d.should_not be_valid
    end         

  end
end
