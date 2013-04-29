class EmailDeliveryService < ActionMailer::Base

  # def deliver_email(email_message, email_args, template_file, inline_attachments = [])
  def deliver_email(email_message, email_args, template_file)

    return unless email_args[:subject].present?
    return unless email_args[:from].present?
    return unless email_args[:to].present?

    if template_file.nil? or template_file == ''
      mail(email_args)
    else

      attachments.inline['logo.jpg'] = File.read('app/assets/images/logo.jpg')

      @email_message = email_message
      mail(email_args) do |format|
        format.html { render template_file }
        format.text { render template_file }
      end
    end  

  end

end
