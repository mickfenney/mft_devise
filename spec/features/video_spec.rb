require 'spec_helper'

describe "Video Create" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @video = FactoryGirl.create(:video)
  end

  it "should be able to create a valid video" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_video_path
    page.should have_selector('h3', text: 'Create Videos')
    fill_in "Name", :with => "My Test Video"
    fill_in "Code", :with => "88888888"
    fill_in "Description", :with => "MyDesString"
    click_button "Create Video"
    page.should have_content("Video was successfully created.")
  end  

  it "should not be able to create a video with the same name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_video_path
    page.should have_selector('h3', text: 'Create Videos')
    fill_in "Name", :with => @video.name
    fill_in "Code", :with => "7777777"
    fill_in "Description", :with => "MyDesString2"
    click_button "Create Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name has already been taken")
  end    

  it "should not be able to create a video with the same code" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_video_path
    page.should have_selector('h3', text: 'Create Videos')
    fill_in "Name", :with => "Test Video 2"
    fill_in "Code", :with => @video.code
    fill_in "Description", :with => "MyDesString2"
    click_button "Create Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Code has already been taken")
  end    

  it "should not be able to create a video with no name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_video_path
    page.should have_selector('h3', text: 'Create Videos')
    fill_in "Name", :with => nil
    fill_in "Code", :with => "88888888"
    fill_in "Description", :with => "MyDesString"    
    click_button "Create Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name can't be blank")
  end   

  it "should not be able to create a video with no code" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit new_video_path
    page.should have_selector('h3', text: 'Create Videos')
    fill_in "Name", :with => "My Test Video"
    fill_in "Code", :with => nil
    fill_in "Description", :with => "MyDesString"    
    click_button "Create Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Code can't be blank")
  end  

end

#######################################################

describe "Video Search" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @video = FactoryGirl.build(:video)
  end

  it "should be able to search for a video" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit videos_path
    page.should have_selector('h3', text: 'Videos')
    click_button "Search"
  end 

end

#######################################################

describe "Video Edit" do

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @video = FactoryGirl.create(:video, :name => "Test Video", :code => "88888888", :description => "MyDesString", :user_id => @admin_user.id)
    @video2 = FactoryGirl.create(:video, :name => "Test Video 3", :code => "555555555", :description => "MyDesString3", :user_id => @admin_user.id)
  end

  it "should be able to edit a video" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_video_path(@video)
    page.should have_selector('h3', text: 'Update Video')
    fill_in "Name", :with => "Test Video 2"
    fill_in "Code", :with => "999999999"
    fill_in "Description", :with => "MyDesString2"
    click_button "Update Video"
    page.should have_content("Video was successfully updated.")
  end 

  it "should not be able to edit a video with no name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_video_path(@video)
    page.should have_selector('h3', text: 'Update Video')
    fill_in "Name", :with => nil
    fill_in "Code", :with => "999999999"
    fill_in "Description", :with => "MyDesString2"    
    click_button "Update Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name can't be blank")
  end   

  it "should not be able to edit a video with no code" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_video_path(@video)
    page.should have_selector('h3', text: 'Update Video')
    fill_in "Name", :with => "Test Video 2"
    fill_in "Code", :with => nil
    fill_in "Description", :with => "MyDesString2"    
    click_button "Update Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Code can't be blank")
  end   

  it "should not be able to edit a video with an already used name" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_video_path(@video)
    page.should have_selector('h3', text: 'Update Video')
    fill_in "Name", :with => "Test Video 3"
    fill_in "Code", :with => "999999999"
    fill_in "Description", :with => "MyDesString2"    
    click_button "Update Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name has already been taken")
  end  

  it "should not be able to edit a video with an already used code" do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)
    visit edit_video_path(@video)
    page.should have_selector('h3', text: 'Update Video')
    fill_in "Name", :with => "Test Video 2"
    fill_in "Code", :with => "555555555"
    fill_in "Description", :with => "MyDesString2"    
    click_button "Update Video"
    page.should have_content("Please review the problems below:")
    page.should have_content("Code has already been taken")
  end   

end