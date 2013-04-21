class NotificationService < ActionMailer::Base

  default :to => "notifications@example.com"

  def send_email(message, email_args, template_file) 

    #raise email_args[:template_data].inspect

    @email_message = message
    # Set defaults...
    #email_args.merge!(from: 'foo')

    mail(email_args) do |format|
    #mail(subject: email_args['subject'], from: email_args['from'], to: email_args['to']) do |format|
      format.html { render template_file }
      format.text { render template_file }
    end
  end  

end
