class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.page(params[:page]).order("name ASC").per_page(10).search(params[:search])
    unless  @users.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    render 'index'
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
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
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end