require 'spec_helper'
 
describe Notification do

  describe "Responds to:" do

    it { Notification.should respond_to :send_email }

  end  

  describe 'send_email' do

    email_message = FactoryGirl.build(:email_message_presenter)
    email_args = {
      subject: "#{ENV["SITE_NAME"]} Contact Us Message",
      from: email_message.email,
      to: ENV["SITE_EMAIL"]
    } 
    template_file = '_templates/email/send_contact_us'     
    let(:mail) { Notification.send_email(email_message, email_args, template_file) }

    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == "#{ENV["SITE_NAME"]} Contact Us Message"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [ENV["SITE_EMAIL"]]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [email_message.email]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(email_message.name)
    end

    #ensure that the @content variable appears in the email body
    it 'assigns @content' do
      mail.body.encoded.should match(email_message.content)
    end    
 
    #ensure that the @root_url variable appears in the email body
    it 'assigns @root_url' do
      mail.body.encoded.should match('example.com')
    end

  end

end
