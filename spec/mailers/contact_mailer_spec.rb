require 'spec_helper'
 
describe ContactMailer do

  describe 'send_contact_message' do

    message = FactoryGirl.build(:message)
    let(:mail) { ContactMailer.send_contact_message(message) }
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'mfTechnology Contact Message'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [ENV["ADMIN_EMAIL"]]
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
      mail.body.encoded.should match(root_url)
    end

  end

end
