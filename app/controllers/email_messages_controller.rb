class EmailMessagesController < ApplicationController

  def new
    @email_message = EmailMessage.new
  end

  def create
    @email_message = EmailMessage.new(params[:email_message])
    if @email_message.valid?
      email_args = {
        subject: "#{ENV["SITE_NAME"]} Contact Us Message",
        from: @email_message.email,
        to: ENV["SITE_EMAIL"]
      }
      template_file = '_templates/email/send_contact_us'
      Notification.send_email(@email_message, email_args, template_file).deliver
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end



