class ContactUsController < ApplicationController

  def new
    @page_title = 'Contact Us'
    name_email = nil
    if user_signed_in? 
      name_email = {:name => current_user.name, :email => current_user.email}
    end
    @email_message = EmailMessagePresenter.new(name_email)
  end

  def create
    @email_message = EmailMessagePresenter.new(params[:email_message_presenter])
    if @email_message.valid?
      PrepareNotification.send_contact_us_email(@email_message)
      redirect_to root_url, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end

end



