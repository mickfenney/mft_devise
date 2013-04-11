class HomeController < ApplicationController
  def index
  	@page_title = 'Home'
    @users = User.all
  end
end
