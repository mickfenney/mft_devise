# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  phone                  :string(255)
#  theme                  :string(255)      default("default")
#

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

    it "should be able to change username and password" do
      user = FactoryGirl.create(:user)
      user.name.should == 'Test User'
      user.password.should == 'changeme'
      user.name = 'New User'
      user.password = 'password'
      user.password_confirmation = 'password'
      user.save
      user.name.should == 'New User'
      user.password.should == 'password'
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
      user = FactoryGirl.build(:user, :theme => 'notheme')
      user.should_not be_valid
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
      user = FactoryGirl.create(:user)
      user.has_role?(:user).should be_true
    end  

    it "should send a invatation email to the invited 'user'" do
      reset_email
      count_email.should == 0
      u1 = FactoryGirl.create(:user)
      u1.add_role(:admin)
      u1.has_role?(:admin).should be_true
      u2 = FactoryGirl.build(:user, :name => 'inviteuser', :email => 'inviteuser@example.com', :invited_by_id => u1.id, :invited_by_type => 'User')
      u2.invite!
      #raise u2.to_yaml
      job = Delayed::Job.first
      Delayed::Job.count.should == 1
      job.invoke_job
      job.destroy
      Delayed::Job.count.should == 0
      count_email.should == 1
      last_email.subject.should == "Invitation instructions"
      last_email.from.should == [ENV["SITE_EMAIL"]]
      last_email.to.should == ['inviteuser@example.com']
      last_email.body.encoded.should include("Someone has invited you")
      last_email.body.encoded.should include("you can accept it through the link below.")
      last_email.body.encoded.should include("If you don't want to accept the invitation, please ignore this email.")
      last_email.body.encoded.should include("Your account won't be created until you access the link above and set your password.")
      last_email.body.encoded.should include(ENV["SITE_NAME"])
      reset_email
      count_email.should == 0  
    end       

  end
end
