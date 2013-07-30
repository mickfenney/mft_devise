class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_theme, :set_time_zone 

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

  	def set_theme
      @css_theme = 'default'
      if user_signed_in?
      	@css_theme = current_user.theme ? current_user.theme : 'default'
      end
  	end

    def set_time_zone
      Time.zone = cookies["time_zone"]
    end  

end
