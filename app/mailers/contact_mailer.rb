class ContactMailer < ActionMailer::Base

  default to: ENV["SITE_EMAIL"]

  def send_contact_message(message)
    @message = message
    mail(subject: ENV["SITE_NAME"]+" Contact Message", from: message.email) do |format|
      format.html
      #format.text
    end
  end

end
