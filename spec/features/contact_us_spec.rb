require 'spec_helper'

describe "Contact Us" do    

  before(:each) do
    @email_message = FactoryGirl.build(:email_message_presenter)
  end

  it "should not email a contact us message with no attributes" do
    visit contact_path
    fill_in "Name", :with => nil
    fill_in "Email", :with => nil
    fill_in "Message", :with => nil
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("Name can't be blank")
    page.should have_content("Email can't be blank")
    page.should have_content("Message can't be blank")
  end  

  it "should not email a contact us message with no name attribute" do
    visit contact_path
    fill_in "Name", :with => nil
    fill_in "Email", :with => @email_message.email
    fill_in "Message", :with => @email_message.content
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end  

  it "should not email a contact us message with invalid email attribute" do
    visit contact_path
    fill_in "Name", :with => @email_message.name
    fill_in "Email", :with => 'invalid_email'
    fill_in "Message", :with => @email_message.content
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("is invalid")
  end  

  it "should not email a contact us message with content attribute having more than 500 characters" do
    visit contact_path
    fill_in "Name", :with => @email_message.name
    fill_in "Email", :with => @email_message.email
    fill_in "Message", :with => Array.new(501, "a").join
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("is too long (maximum is 500 characters)")
  end   

  it "should email a contact us message with valid attributes" do
    reset_email
    visit contact_path
    fill_in "Name", :with => @email_message.name
    fill_in "Email", :with => @email_message.email
    fill_in "Message", :with => @email_message.content
    click_button "Send Message"
    page.should have_content("Message sent! Thank you for contacting us.")
    job = Delayed::Job.first
    Delayed::Job.count.should == 1
    job.attributes['handler'].should match("#{ENV["SITE_NAME"]} Contact Us Message")    
    job.attributes['handler'].should match(@email_message.email)
    job.attributes['handler'].should match(ENV["SITE_EMAIL"])
    job.attributes['handler'].should match(ENV["SITE_NAME"])
    #raise job.to_yaml
    job.invoke_job
    job.destroy
    Delayed::Job.count.should == 0
    count_email.should == 1
    last_email.subject.should == "#{ENV["SITE_NAME"]} Contact Us Message"
    last_email.from.should == [@email_message.email]
    last_email.to.should == [ENV["SITE_EMAIL"]]
    last_email.body.encoded.should include(ENV["SITE_NAME"])
    reset_email
    count_email.should == 0
  end    

end
