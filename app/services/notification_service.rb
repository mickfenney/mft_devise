class NotificationService < ActionMailer::Base

  # Set defaults...
  default :to => ENV["SITE_EMAIL"]
  default :from => ENV["SITE_EMAIL"]
  default :subject => "Message from #{ENV["SITE_NAME"]}"

  def send_email(email_message, email_args, template_file)

    attachments.inline['logo.jpg'] = File.read('app/assets/images/logo.jpg')

    if email_args.nil? or email_args == ''
      email_args = {}
    end

    @email_message = email_message

   _send_email(email_args, template_file)

  end  

  private

   def _send_email(email_args, template_file)

    mail(email_args) do |format|
      format.html { render template_file }
      format.text { render template_file }
    end 

   end

end
