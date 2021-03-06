# == Schema Information
#
# Table name: pictures
#
#  id         :integer          not null, primary key
#  gallery_id :integer
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

require 'spec_helper'

describe Picture do

  it { should respond_to(:name) }
  it { should respond_to(:image) }
  it { should respond_to(:remote_image_url) }
  it { should respond_to(:gallery_id) }
  it { should respond_to(:user_id) }

  it { should strip_attribute :name }
  it { should_not strip_attribute :gallery_id }  
  it { should_not strip_attribute :user_id }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes", :vcr  do
      p = FactoryGirl.create(:picture)
      p.should be_valid
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/picture/image/#{p.id}", :force => true)
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it 'should reject a name that is too long' do
      p = FactoryGirl.build(:picture, :name => Array.new(256, "a").join)
      p.should_not be_valid
    end

    it 'should not accept a blank name', :vcr do
      p = FactoryGirl.build(:picture, :name => '')
      p.should be_valid
    end  

    it "should not create a new instance given a nil 'name' attribute", :vcr do
      p = FactoryGirl.build(:picture, :name => nil)
      p.should be_valid
    end           

    it "should accept valid user id", :vcr do
      p = FactoryGirl.build(:picture)
      p.should be_valid
    end  

    it 'should not accept a blank user id' do
      p = FactoryGirl.build(:picture, :user_id => '')
      p.should_not be_valid
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/tmp", :force => true)
    end       

  end
end
