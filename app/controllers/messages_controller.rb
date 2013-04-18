class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      email_args = {
        "subject" => ENV["SITE_NAME"]+" Contact Us Message",
        "from" => @message.email,
        "to" => ENV["SITE_EMAIL"], 
        "template_file" => '_templates/email/send_contact_us'
      }
      Notification.send_email(@message, email_args).deliver
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end



