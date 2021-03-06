module UserHelper

  def avatar_url(user, size = 48)
    if user.image_url && user.is_image == true
      return user.image_url
    else  
      default_url = "#{root_url}assets/anonymous48.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)

      if ENV['RAILS_ENV'] == "development" then
        return("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}")
      else
        #return("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}") 
        return("http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}")
      end      
    end  
  end

end
