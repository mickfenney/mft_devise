require 'spec_helper'

describe "Contact Us" do    

  before(:each) do
    @message = FactoryGirl.build(:message)
    ContactMailer.send_contact_message(@message)
  end

  it "should email a contact us message with valid attributes" do
    reset_email
    visit contact_path
    fill_in "Name", :with => @message.name
    fill_in "Email", :with => @message.email
    fill_in "Message", :with => @message.content
    click_button "Send Message"
    page.should have_content("Message sent! Thank you for contacting us.")
    last_email.body.should include('example.com')
  end

  it "should not email a contact us message with no attributes" do
    visit contact_path
    fill_in "Name", :with => nil
    fill_in "Email", :with => nil
    fill_in "Message", :with => nil
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
    page.should have_content("is invalid")
  end  

  it "should not email a contact us message with no name attribute" do
    reset_email
    visit contact_path
    fill_in "Name", :with => nil
    fill_in "Email", :with => @message.email
    fill_in "Message", :with => @message.content
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("can't be blank")
  end  

  it "should not email a contact us message with invalid email attribute" do
    visit contact_path
    fill_in "Name", :with => @message.name
    fill_in "Email", :with => 'invalid_email'
    fill_in "Message", :with => @message.content
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("is invalid")
  end  

  it "should not email a contact us message with content attribute having more than 500 characters" do
    visit contact_path
    fill_in "Name", :with => @message.name
    fill_in "Email", :with => @message.email
    fill_in "Message", :with => Array.new(501, "a").join
    click_button "Send Message"
    page.should have_content("Please review the problems below:")
    page.should have_content("is too long (maximum is 500 characters)")
  end     

end
