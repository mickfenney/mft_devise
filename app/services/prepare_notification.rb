class PrepareNotification

  def self.send_contact_us_email(email_message)

    email_args = {
      subject: "#{ENV["SITE_NAME"]} Contact Us Message",
      from: email_message.email,
      to: "#{ENV["SITE_NAME"]} <#{ENV["SITE_EMAIL"]}>"
    }

    template_file = '_templates/email/send_contact_us'

    delay_args = { 
      queue: "email", 
      priority: 100
    }

    NotificationService.send_email(email_message, email_args, template_file, delay_args)

  end

end
