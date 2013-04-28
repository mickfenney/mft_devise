module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end
  
  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def count_email
    ActionMailer::Base.deliveries.count
  end  
end

