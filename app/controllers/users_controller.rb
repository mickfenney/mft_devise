class UsersController < ApplicationController

  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Search User'
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
    @user = User.find(params[:id])
    if @user == current_user
      respond_to do |format|
        format.html { redirect_to edit_user_registration_path }
        format.json { head :no_content }
      end
    end
  end
  
  def update
    @user.skip_reconfirmation!
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end    
  end
    
  def destroy
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: "User #{user.name} was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_path, notice: "Can't delete yourself." }
        format.json { head :no_content }
      end
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