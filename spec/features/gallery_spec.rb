require 'spec_helper'

describe "Picture Gallery Create" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @gallery = FactoryGirl.create(:gallery)
  end

  it "should be able to create a valid gallery" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_gallery_path
    page.should have_selector('h3', text: 'Create Picture Gallery')
    fill_in "Name", :with => "My Test Gallery"
    click_button "Create Gallery"
    page.should have_content("Successfully created gallery.")
  end  

  it "should not be able to create a gallery with the same name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_gallery_path
    page.should have_selector('h3', text: 'Create Picture Gallery')
    fill_in "Name", :with => @gallery.name
    click_button "Create Gallery"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name has already been taken")
  end    

  it "should not be able to create a gallery with no name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_gallery_path
    page.should have_selector('h3', text: 'Create Picture Gallery')
    fill_in "Name", :with => nil
    click_button "Create Gallery"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name can't be blank")
  end   

end

#######################################################

describe "Picture Gallery Search" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @gallery = FactoryGirl.build(:gallery)
  end

  it "should be able to search for a picture gallery" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit galleries_path
    page.should have_selector('h3', text: 'Picture Galleries')
    click_button "Search"
  end 

end

#######################################################

describe "Picture Gallery Edit" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @gallery = FactoryGirl.create(:gallery, :name => "Test Gallery", :user_id => @admin_user.id)
    @gallery2 = FactoryGirl.create(:gallery, :name => "Test Gallery 3", :user_id => @admin_user.id)
  end

  it "should be able to edit a picture gallery" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_gallery_path(@gallery)
    page.should have_selector('h3', text: 'Edit Picture Gallery')
    fill_in "Name", :with => "Test Gallery 2"
    click_button "Update Gallery"
    page.should have_content("Successfully updated gallery")
  end 

  it "should not be able to edit a picture gallery with no name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_gallery_path(@gallery)
    page.should have_selector('h3', text: 'Edit Picture Gallery')
    fill_in "Name", :with => nil
    click_button "Update Gallery"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name can't be blank")
  end   

  it "should not be able to edit a picture gallery with an already used name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_gallery_path(@gallery)
    page.should have_selector('h3', text: 'Edit Picture Gallery')
    fill_in "Name", :with => "Test Gallery 3"
    click_button "Update Gallery"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name has already been taken")
  end    

end
