class UsersController < ApplicationController

  load_and_authorize_resource

  #before_filter :authenticate_user!

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Search User'
    #authorize! :index, @user, :message => 'You are not authorized to access this page.'
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    unless  @users.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    if params[:report] == 'csv'
      @users_all = User.search(params[:search]).order(sort_column + " " + sort_direction)
      respond_to do |format|
        format.csv { send_data @users_all.to_csv }
      end
    else
      render 'index'
    end
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

  private
  
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end