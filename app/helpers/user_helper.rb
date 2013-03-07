module UserHelper

  def avatar_url(user, size = 48)
    default_url = "#{root_url}assets/anonymous48.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)

    if ENV['RAILS_ENV'] == "development" then
      return("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}")
    else
      return("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}")
    end
  end

  def pagination_links(collection, options = {})
   options[:renderer] ||= BootstrapPaginationHelper::LinkRenderer
   options[:class] ||= 'pagination pagination-left'
   options[:inner_window] ||= 2
   options[:outer_window] ||= 1
   options[:previous_label] ||= h("<< Previous")
   options[:next_label] ||= h("Next >>")
   will_paginate(collection, options)
 end

end
