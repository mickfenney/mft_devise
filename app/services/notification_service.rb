class NotificationService

  def self.send_email(email_message, email_args, template_file, delay_args, inline_attachments)
    
    return unless email_args[:subject].present?
    return unless email_args[:from].present?
    return unless email_args[:to].present?

    if delay_args.nil? or delay_args == ''
      delay_args = {}
    end 

    @email_message = email_message

    inline_attachments = [inline_attachments] if inline_attachments.is_a? String

    email_args[:to] = [email_args[:to]] if email_args[:to].is_a? String

    email_args[:to].each do |address| 
      single_email_args = {
        subject: email_args[:subject],
        from: email_args[:from],
        to: address
      } 
      EmailDeliveryService.delay(delay_args).deliver_email(@email_message, single_email_args, template_file, inline_attachments)
    end
  end  

end
