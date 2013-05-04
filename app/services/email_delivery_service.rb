class EmailDeliveryService < ActionMailer::Base

  def deliver_email(email_message, email_args, template_file, inline_attachments = [])

    return unless email_args[:subject].present?
    return unless email_args[:from].present?
    return unless email_args[:to].present? 

    @email_message = email_message

    unless inline_attachments.nil? or inline_attachments == ''
      inline_attachments.each do |inline_attach|
        attachments.inline[File.basename(inline_attach)] = File.read(inline_attach)
      end  
    end     

    if template_file.nil? or template_file == ''
      mail(email_args)
    else
      mail(email_args) do |format|
        format.html { render template_file }
        #format.text { render template_file }
      end
    end  

  end

end
