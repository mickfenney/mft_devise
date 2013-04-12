class ContactMailer < ActionMailer::Base

  default to: ENV["ADMIN_EMAIL"]

  def send_contact_message(message)
    @message = message
    mail(subject: "mfTechnology Contact Message", from: message.email) do |format|
      format.html
      #format.text
    end
  end

end
