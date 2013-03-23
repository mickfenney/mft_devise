require 'spec_helper'

describe User do

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }
  it { should respond_to(:theme) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should strip_attribute :name }
  it { should strip_attribute :email }
  it { should_not strip_attribute :phone }
  it { should_not strip_attribute :password }
  it { should_not strip_attribute :password_confirmation }

################################################################################
  describe "Class Instantiation:" do
    it "should create a new instance given valid attributes" do
      user = FactoryGirl.create(:user)
      user.should be_valid
    end
  end
################################################################################
  describe "Class Data Memeber Validation:" do

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = FactoryGirl.build(:user, :email => address)
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = FactoryGirl.build(:user, :email => address)
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      u1 = FactoryGirl.create(:user, :email => 'user@example.com')
      u2 = FactoryGirl.build(:user, :email => 'user@example.com')
      u2.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      email = 'user@example.com'
      u1 = FactoryGirl.create(:user, :email => email)
      u2 = FactoryGirl.build(:user, :email => email.upcase)
      u2.should_not be_valid
    end

    it "should require a password" do
      no_pw = FactoryGirl.build(:user, :password => nil, :password_confirmation => nil)
      no_pw.should_not be_valid
    end

    it "should require a matching password confirmation" do
      unmatched_pw = FactoryGirl.build(:user, :password => 'thispassword', :password_confirmation => 'thatpassword')
      unmatched_pw.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      short_pw = FactoryGirl.build(:user, :password => short, :password_confirmation => short)
      short_pw.should_not be_valid
    end

    describe "password encryption" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should set the encrypted password attribute" do
        @user.encrypted_password.should_not be_blank
      end
    end

    it "should not accept more than 15 char phone number" do
      user = FactoryGirl.build(:user, :phone => '123456789123456789')
      user.should_not be_valid
    end

    it "should accept up to 15 char phone number" do
      user = FactoryGirl.build(:user, :phone => '+61 000 000 000')
      user.should be_valid
    end    

    it "should not create a new instance given and invalid 'theme' (enum) attribute" do
      expect {
        user = FactoryGirl.build(:user, :theme => 'notheme')
      }.to raise_error
    end    

    it "should not create a new instance given a nil 'theme' (enum) attribute" do
      user = FactoryGirl.build(:user, :theme => nil)
      user.should_not be_valid
    end

    it "should accept valid theme" do
      user = FactoryGirl.build(:user, :theme => 'default')
      user.should be_valid
    end 

    it "should automatically set the role as 'user'" do
      user = FactoryGirl.build(:user)
      user.add_role(:user)
      user.has_role?(:user).should be_true
    end    

  end
end
