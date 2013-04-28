class EmailDeliveryService < ActionMailer::Base

  def deliver_email(email_message, email_args, template_file)

    return unless email_args[:to].present?
    return unless email_args[:from].present?
    return unless email_args[:subject].present?

    attachments.inline['logo.jpg'] = File.read('app/assets/images/logo.jpg')

    @email_message = email_message

    if email_args.nil? or email_args == ''
      email_args = {}
    end

    mail(email_args) do |format|
      format.html { render template_file }
      format.text { render template_file }
    end     
  end

end
