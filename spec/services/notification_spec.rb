require 'spec_helper'
 
describe Notification do

  describe "Responds to:" do

    it { Notification.should respond_to :send_email }

  end  

  describe 'send_email' do

    message = FactoryGirl.build(:message)
    email_args = {
      "subject" => ENV["SITE_NAME"]+" Contact Us Message",
      "from" => message.email,
      "to" => ENV["SITE_EMAIL"], 
      "template_file" => '_templates/email/send_contact_us'
    }      
    let(:mail) { Notification.send_email(message, email_args) }

    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == ENV["SITE_NAME"]+' Contact Us Message'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [ENV["SITE_EMAIL"]]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [message.email]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      mail.body.encoded.should match(message.name)
    end

    #ensure that the @content variable appears in the email body
    it 'assigns @content' do
      mail.body.encoded.should match(message.content)
    end    
 
    #ensure that the @root_url variable appears in the email body
    it 'assigns @root_url' do
      mail.body.encoded.should match('http://example.com/')
    end

  end

end
