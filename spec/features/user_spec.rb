require 'spec_helper'

describe "User" do 

  subject { page }

  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  describe "Sign In" do
    before { visit "#{root_path}users/sign_in" }
    
    it { should have_selector('h3', text: 'Sign In') }
  end 

  it "should be able to login with valid user" do
  	pending
  end 	

end	