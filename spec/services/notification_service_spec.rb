require 'spec_helper'
 
describe NotificationService do

  describe "Responds to:" do

    it { NotificationService.should respond_to :send_email }

  end  

  describe 'single and multiple email addresses' do

    it "should not send an email message when no 'to' address is present" do
      email_args = {
        subject: "Single address test email",
        from: ENV["SITE_EMAIL"],
      } 
      email_message = FactoryGirl.build(:email_message_presenter)
      template_file = '_templates/email/send_contact_us'     
      inline_attachments = 'app/assets/images/email_header.png'
      delay_args = { 
        queue: "email", 
        priority: 100
      }

      NotificationService.send_email(email_message, email_args, template_file, delay_args, inline_attachments)

      job = Delayed::Job.first

      Delayed::Job.count.should == 0
    end

    it "should send single email message when given a string address" do
      email_args = {
        subject: "Single address test email",
        from: ENV["SITE_EMAIL"],
        to: "user@example.com"
      } 
      email_message = FactoryGirl.build(:email_message_presenter)
      template_file = '_templates/email/send_contact_us'     
      inline_attachments = 'app/assets/images/email_header.png'
      delay_args = { 
        queue: "email", 
        priority: 100
      }

      NotificationService.send_email(email_message, email_args, template_file, delay_args, inline_attachments)

      job = Delayed::Job.first

      Delayed::Job.count.should == 1
    end

    it "should send multiple email messages when given an array of addresses" do
      qty = 3
      recipients = []
      qty.times {|i| recipients.push "user_#{i}@example.com"}

      email_args = {
        subject: "Multi address test email",
        from: ENV["SITE_EMAIL"],
        to: recipients
      } 
      email_message = FactoryGirl.build(:email_message_presenter)
      template_file = '_templates/email/send_contact_us' 
      inline_attachments = 'app/assets/images/email_header.png'
      delay_args = { 
        queue: "email", 
        priority: 100
      }

      NotificationService.send_email(email_message, email_args, template_file, delay_args, inline_attachments)

      job = Delayed::Job.first

      Delayed::Job.count.should == qty
    end

  end  

  describe 'send email with template file and delay args' do

    # email_message = FactoryGirl.build(:email_message_presenter)
    # email_args = {
    #   subject: "#{ENV["SITE_NAME"]} Contact Us Message",
    #   from: email_message.email,
    #   to: ENV["SITE_EMAIL"]
    # } 
    # template_file = '_templates/email/send_contact_us'     
    # delay_args = { 
    #   queue: "email", 
    #   priority: 100
    # }
    # let(:mail) { NotificationService.send_email(email_message, email_args, template_file, delay_args) }

    # #ensure that the subject is correct
    # it 'renders the subject' do
    #   mail.subject.should == "#{ENV["SITE_NAME"]} Contact Us Message"
    # end

    before (:each) do
      @email_message = FactoryGirl.build(:email_message_presenter)
      email_args = {
        subject: "#{ENV["SITE_NAME"]} - This is a Test Message",
        from: @email_message.email,
        to: ENV["SITE_EMAIL"]
      } 
      template_file = '_templates/email/send_contact_us'     
      inline_attachments = ['app/assets/images/email_header.png']
      delay_args = { 
        queue: "email", 
        priority: 100
      }      
      NotificationService.send_email(@email_message, email_args, template_file, delay_args, inline_attachments)
      job = Delayed::Job.first
      job.invoke_job
      job.destroy
    end

    #ensure that the subject is correct
    it 'renders the subject' do
      last_email.subject.should == "#{ENV["SITE_NAME"]} - This is a Test Message"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      last_email.to.should == [ENV["SITE_EMAIL"]]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      last_email.from.should == [@email_message.email]
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns @name' do
      last_email.body.encoded.should match(@email_message.name)
    end

    #ensure that the @content variable appears in the email body
    it 'assigns @content' do
      last_email.body.encoded.should match(@email_message.content)
    end    
 
    #ensure that the @root_url variable appears in the email body
    it 'assigns @root_url' do
      last_email.body.encoded.should match('example.com')
    end

    #ensure that the site name variable appears in the email body
    it 'assigns site name' do
      last_email.body.encoded.should match(ENV["SITE_NAME"])
    end  

    #ensure that the inline attachment variable appears in the email body
    it 'assigns inline attachment' do
      last_email.body.encoded.should match('email_header.png')
    end     

    #ensure that the inline attachments variable appears in the email body
    it 'assigns multipy inline attachments' do
      last_email.body.encoded.should match('email_header.png')
    end             

  end

  describe 'send email with no template file, no delay args and inline attachments' do

    before (:each) do
      @email_message = FactoryGirl.build(:email_message_presenter)
      email_args = {
        subject: "#{ENV["SITE_NAME"]} - This is a Test Message",
        from: @email_message.email,
        to: ENV["SITE_EMAIL"]
      }   
      NotificationService.send_email(nil, email_args, nil, nil, nil)
      job = Delayed::Job.first
      job.invoke_job
      job.destroy
    end

    #ensure that the subject is correct
    it 'renders the subject' do
      last_email.subject.should == "#{ENV["SITE_NAME"]} - This is a Test Message"
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      last_email.to.should == [ENV["SITE_EMAIL"]]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      last_email.from.should == [@email_message.email]
    end
 
    #ensure that the email body is blank
    it 'assigns body' do
      last_email.body.encoded.should be_blank
    end  

  end  

end