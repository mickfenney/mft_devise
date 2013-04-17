class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      email_args = {
        template_data: @message, 
        template_file: '_templates/email/send_contact_us', 
        to: ENV["SITE_EMAIL"], 
        subject: ENV["SITE_NAME"]+" Contact Us Message",
        from: @message.email,
        name: @message.name
      }
      Notification.send_email(email_args).deliver
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end



