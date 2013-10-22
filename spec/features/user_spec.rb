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
    count_email.should == 0
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

#######################################################

describe 'Search User' do    

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @user = FactoryGirl.create(:user, :name => 'New User', :email => 'new@example.com')
  end 

  it 'should be able to search for a user' do
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name) 
    visit users_path
    page.should have_selector('h3', text: 'Users')
    fill_in 'search', :with => 'nomatch' 
    click_button "Search"
    page.should have_content("Your search for 'nomatch' did not return any results")
    fill_in 'search', :with => 'Test'
    click_button "Search"
    page.should have_content("example@example.com")
    fill_in 'search', :with => 'New'
    click_button "Search"
    page.should have_content("new@example.com")
    fill_in 'search', :with => ''
    click_button "Search"
    page.should have_content("example@example.com")
    page.should have_content("new@example.com")
    #save_and_open_page
  end

  it 'should be redirected to home page if you are not an admin user' do
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@user.name) 
    visit users_path
    page.should have_selector('h3', text: 'Home')
    page.should have_content("You are not authorized to access this page.")
  end  

  it 'should be able to show pagination' do
    50.times do
      user = FactoryGirl.create(:user, :name => Faker::Name.name, :email => Faker::Internet.email)
    end
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name) 
    visit users_path
    page.should have_selector('h3', text: 'Users')
    page.should have_content("Previous 1 2 3 4 5 6 Next")
  end 

end

#######################################################

describe 'Update User Details' do 

  before(:each) do
    @admin_user = FactoryGirl.create(:user)
    @admin_user.add_role(:admin)
    @admin_user.has_role?(:admin).should be_true
    @user = FactoryGirl.create(:user, :name => 'New User', :email => 'new@example.com')
    visit new_user_session_path
    fill_in "Email", :with => @admin_user.email
    fill_in "Password", :with => @admin_user.password
    click_button "Sign in"
    page.should have_content("Signed in successfully.")
    page.should have_content(@admin_user.name)    
  end 

  it 'should have certain content on the user edit page' do
    visit edit_user_registration_path

    # General Tab
    page.should have_content("General")

    # Profile Image Tab
    page.should have_content('Profile Image')    
    page.should have_link('Change Gravatar', href: 'http://www.gravatar.com/emails')
    # OR:
    find_link('Change Gravatar')[:href].should == 'http://www.gravatar.com/emails'

    # Locations Tab
    page.should have_content('Locations')
    page.should have_content('+ Add Location')

    # Password Tab
    page.should have_content('Password')
    page.should have_content('Password confirmation')
    page.should have_content('Current password')

    # Cancel my Account Tab
    page.should have_content('Cancel my Account')
    page.should have_content('Unhappy? Cancel my account.')
  end  

  it 'should allow a user to update there General details' do
    visit edit_user_registration_path
    page.should have_selector('h3', text: 'Edit User: Test User')
    fill_in "Name", :with => 'new name'
    fill_in "Phone", :with => '0000 222 444'
    select "Slate", :from => 'Theme'
    fill_in "general password", :with => @admin_user.password
    click_button "Update General"
    page.should have_content("You updated your account successfully.")
    #raise User.first.to_yaml
    User.first.name.should == "new name"
    User.first.phone.should == "0000222444"
    User.first.theme.should == "slate"   
  end  

   it 'should allow an admin user to update a users General details' do
    visit root_url+"/users/"+@user.id.to_s+"/edit"
    page.should have_selector('h3', text: 'Edit New User')
    fill_in "Name", :with => 'a new name'
    fill_in "Phone", :with => '0000 333 555'
    select "Slate", :from => 'Theme'
    click_button "Update General"
    page.should have_content("User was successfully updated.")
    u = User.find_by_id(@user.id)
    #raise u.to_yaml
    u.name.should == "a new name"
    u.phone.should == "0000333555"
    u.theme.should == "slate"
  end 

  it 'should not allow a user to update invalid details' do
    visit edit_user_registration_path
    page.should have_selector('h3', text: 'Edit User: Test User')
    fill_in "Name", :with => nil
    fill_in "Phone", :with => '1234'
    fill_in "general password", :with => nil
    click_button "Update General"
    page.should have_content("Please review the problems below:")
    page.should have_content("Phone is too short (minimum is 8 characters") 
    page.should have_content("can't be blank")
  end

end 

#######################################################

describe 'Lock User' do    

  before(:each) do
    @user = FactoryGirl.create(:user)
  end 

  it "should lock the account and send an Unlock Instructions email" do
    reset_email
    count_email.should == 0
    visit new_user_session_path
    21.times do
        fill_in "Email", :with => @user.email
        fill_in "Password", :with => 'wrong_password'
        click_button "Sign in"
    end    
    job = Delayed::Job.first
    Delayed::Job.count.should == 1
    page.should have_content("Your account is locked.")
    job.invoke_job
    job.destroy
    Delayed::Job.count.should == 0
    count_email.should == 1
    last_email.subject.should == "Unlock Instructions"
    last_email.body.encoded.should include("Click the link below to unlock your account:")
    last_email.body.encoded.should include(ENV["SITE_NAME"])
    reset_email
    count_email.should == 0      
  end    
 
end