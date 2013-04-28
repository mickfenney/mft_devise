class EmailDeliveryService < ActionMailer::Base

  def send_email(email_message, email_args, template_file)

    return unless email_args[:to].present?
    return unless email_args[:from].present?
    return unless email_args[:subject].present?

    attachments.inline['logo.jpg'] = File.read('app/assets/images/logo.jpg')

    if email_args.nil? or email_args == ''
      email_args = {}
    end

    # if delay_args.nil? or delay_args == ''
    #   delay_args = {}
    # end    

    @email_message = email_message

    email_args[:to] = [email_args[:to]] if email_args[:to].is_a? String

    email_args[:to].each do |address| 
      single_email_args = {
        subject: email_args[:subject],
        from: email_args[:from],
        to: address
      } 
      _send_email(single_email_args, template_file)
    end
  end  

  private

   def _send_email(email_args, template_file)
    mail(email_args) do |format|
      format.html { render template_file }
      format.text { render template_file }
    end 
   end

   #handle_asynchronously :_send_email, &delay_args

end
