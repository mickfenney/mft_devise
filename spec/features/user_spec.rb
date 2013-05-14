require 'spec_helper'

describe "User Sign In" do 

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should be able to login as a valid user" do
    visit "#{root_path}users/sign_in"
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)
  end 	

  it "should not be able to login as a non valid user" do
    visit "#{root_path}users/sign_in"
    fill_in "Email", :with => nil
    fill_in "Password", :with => nil
    click_button "Sign in"
    page.should have_content("Invalid email or password.")
  end   

  it "should redirect to Edit User page when clicking Edit link on User page" do
    visit "#{root_path}users/sign_in"
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)
    click_link @user.name
    page.should have_selector('h3', text: 'User')
    page.should have_content("Edit")
    click_link "Edit"
    page.should have_selector('h3', text: "Edit User: #{@user.name}")
    page.should have_content("General")
    page.should have_content("Profile Image")
    page.should have_content("Locations")
    page.should have_content("Password")
    page.should have_content("Cancel my Account")
  end    

end	