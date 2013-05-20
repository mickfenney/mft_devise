require 'spec_helper'

describe "User Sign In" do 

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should be able to login as a valid user" do
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)
  end 	

  it "should not be able to login as a non valid user" do
    visit new_user_session_path
    fill_in "Email", :with => nil
    fill_in "Password", :with => nil
    click_button "Sign in"
    page.should have_content("Invalid email or password.")
  end   

  it "should redirect to Edit User page when clicking Edit link on User page" do
    visit new_user_session_path
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

#######################################################

describe 'User Sign Up' do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end   

  it 'should not allow a new user to sign up with an blank name' do
    visit new_user_registration_path
    fill_in 'Name', :with => nil
    fill_in 'Email', :with => 'newuser@example.com'
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end 

  it 'should not allow a new user to sign up with a blank email' do
    visit new_user_registration_path
    fill_in 'Name', :with => nil
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end  

  it 'should not allow a new user to sign up with an invalid email' do
    visit new_user_registration_path
    fill_in 'Name', :with => 'New User'
    fill_in 'Email', :with => 'is_a_invalid_email'
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("is invalid")
  end     

  it 'should not allow a new user to sign up with an already valid user email' do
    visit new_user_registration_path
    fill_in 'Name', :with => 'New User'
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("has already been taken")
  end

  it 'should not allow a new user to sign up with blank passwords' do
    visit new_user_registration_path
    fill_in 'Name', :with => 'New User'
    fill_in 'Email', :with => 'newuser@example.com'
    fill_in 'Password', :with => nil
    fill_in 'Password confirmation', :with => nil
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end

  it 'should not allow a new user to sign up with mismatched passwords' do
    visit new_user_registration_path
    fill_in 'Name', :with => 'New User'
    fill_in 'Email', :with => 'newuser@example.com'
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'mismatchedpassword'
    click_button 'Sign up'
    page.should have_content("Please review the problems below:")
    page.should have_content("doesn't match confirmation")
  end   

  it 'should allow a new user to sign up with valid details' do
    visit new_user_registration_path
    fill_in 'Name', :with => 'New User'
    fill_in 'Email', :with => 'newuser@example.com'
    fill_in 'Password', :with => 'userpassword'
    fill_in 'Password confirmation', :with => 'userpassword'
    click_button 'Sign up'
    page.should have_content("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.")
  end        

end

#######################################################

describe 'User Forgot password' do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end  

  it 'should allow a user to recover password' do
    reset_email
    visit new_user_session_path
    click_link 'Forgot your password?'
    fill_in 'Email', :with => @user.email
    click_button 'Send me reset password instructions'
    job = Delayed::Job.first
    Delayed::Job.count.should == 1
    job.attributes['handler'].should match(":reset_password_instructions")
    job.attributes['queue'].should match("devise_email")
    #raise job.to_yaml
    job.invoke_job
    job.destroy
    Delayed::Job.count.should == 0
    count_email.should == 1
    last_email.subject.should == "Reset password instructions"
    last_email.from.should == [ENV["SITE_EMAIL"]]
    last_email.to.should == [@user.email]
    last_email.body.encoded.should include("Someone has requested a link to change your password. You can do this through the link below.")
    last_email.body.encoded.should include(ENV["SITE_NAME"])
    reset_email
    count_email.should == 0
  end 

end

#######################################################

describe 'Invite User' do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end   

  it 'should not allow a new user to be invited with no email' do
    reset_email
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)    
    visit new_user_invitation_path
    fill_in 'Name', :with => 'Invited User'
    fill_in 'Email', :with => nil
    click_button 'Send an invitation'
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end  

  it 'should not allow a new user to be invited with invalid email' do
    reset_email
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)    
    visit new_user_invitation_path
    fill_in 'Name', :with => 'Invited User'
    fill_in 'Email', :with => 'invalid_email'
    click_button 'Send an invitation'
    page.should have_content("Please review the problems below:")
    page.should have_content("is invalid")
  end  

  it 'should not allow a new user to be re-invited' do
    reset_email
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)    
    visit new_user_invitation_path
    fill_in 'Name', :with => @user.name
    fill_in 'Email', :with => @user.email
    click_button 'Send an invitation'
    page.should have_content("Please review the problems below:")
    page.should have_content("has already been taken")
  end      

  it 'should allow a new user to be invited' do
    reset_email
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name)    
    visit new_user_invitation_path
    fill_in 'Name', :with => 'Invited User'
    fill_in 'Email', :with => 'inviteuser@example.com' 
    click_button 'Send an invitation'
    job = Delayed::Job.first
    Delayed::Job.count.should == 1
    page.should have_content("An invitation email has been sent to inviteuser@example.com.")
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