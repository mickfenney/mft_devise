class UsersController < ApplicationController

  load_and_authorize_resource

  #before_filter :authenticate_user!

  def index
    @page_title = 'Search User'
    #authorize! :index, @user, :message => 'You are not authorized to access this page.'
    @users = User.page(params[:page]).order("name ASC").per_page(10).search(params[:search])
    unless  @users.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    render 'index'
  end

  def show
    @page_title = 'Show User'
    @user = User.find(params[:id])
  end

  def edit
    @page_title = 'Edit User'
    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
  end
  
  def update
    #authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      params[:user].each do |key, value|
        if key == 'password'
          redirect_to users_path, :notice => "User #{@user.name} password updated."
          break
        else
          redirect_to users_path, :notice => "User #{@user.name} updated."
          break
        end
      end      
    else
      params[:user].each do |key, value|
        if key == 'password'
          redirect_to users_path, :alert => "Unable to update user #{@user.name} password."
          break
        else
          redirect_to users_path, :alert => "Unable to update #{@user.name} user."
          break
        end
      end
    end
  end
    
  def destroy
    #authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end