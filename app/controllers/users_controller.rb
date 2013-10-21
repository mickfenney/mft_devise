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
    render 'index'
  end

  def users
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.csv { send_data @users.to_csv }
    end
  end 

  def import 
    org_file = 'NoFile'
    org_file = params[:file].original_filename if params[:file].present?
    if org_file !~ /csv$/i && org_file !~ /txt$/i && params[:file].present?
      respond_to do |format|
        format.html { redirect_to users_path, alert: "This import file <b>#{org_file}</b> is invalid, it needs to be a <b>csv</b> or a comma delimited <b>txt</b> file.".html_safe }
      end
    elsif request.post? && params[:file].present?
      @users = User.import(params[:file])
      if @users.to_s =~ /Error Line:/
        respond_to do |format|
          format.html { redirect_to users_path, alert: @users.to_s.gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
        end
      else
        if @users.to_s =~ /\*\*\*SUCCESS:\*\*\*/
          respond_to do |format|
            format.html { redirect_to users_path, notice: @users.to_s.gsub(/Errors have prohibited this import from completing:/, "The import file <b>#{org_file}</b> has successfully loaded").gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
          end
        else
          respond_to do |format|
            format.html { redirect_to users_path, alert: "Errors have prohibited this import from completing:<br/>The file contains no data.".html_safe }
          end        
        end
      end
    else  
      respond_to do |format|
        format.html { redirect_to users_path, alert: 'Select a valid csv file for import.' }
      end
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
    if params[:user] == nil
      redirect_to "#{users_path}/#{@user.id}/edit", :alert => "Unable to update #{@user.name} user."
      return
    end    
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
          redirect_to "#{users_path}/#{@user.id}/edit", :alert => "Unable to update user #{@user.name} password."
          break
        else
          redirect_to "#{users_path}/#{@user.id}/edit", :alert => "Unable to update #{@user.name} user."
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