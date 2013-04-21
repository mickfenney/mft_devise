class ContactUsController < ApplicationController

  def new
    @email_message = EmailMessagePresenter.new
  end

  def create
    @email_message = EmailMessagePresenter.new(params[:email_message_presenter])
    if @email_message.valid?
      email_args = {
        subject: "#{ENV["SITE_NAME"]} Contact Us Message",
        from: @email_message.email,
        to: ENV["SITE_EMAIL"]
      }
      template_file = '_templates/email/send_contact_us'
      NotificationService.send_email(@email_message, email_args, template_file).deliver
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end



