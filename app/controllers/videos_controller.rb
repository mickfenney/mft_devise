class VideosController < ApplicationController
  
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Search Video'
    @videos = Video.search(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    unless  @videos.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    render 'index'
  end  

   def videos
    @videos = Video.search(params[:search]).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.csv { send_data @videos.to_csv }
    end
  end   

  def import 
    org_file = 'NoFile'
    org_file = params[:file].original_filename if params[:file].present?
    if org_file !~ /csv$/i && org_file !~ /txt$/i && params[:file].present?
      respond_to do |format|
        format.html { redirect_to videos_path, alert: "This import file <b>#{org_file}</b> is invalid, it needs to be a <b>csv</b> or a comma delimited <b>txt</b> file.".html_safe }
      end
    elsif request.post? && params[:file].present?
      @videos = Video.import(params[:file])
      if @videos.to_s =~ /Error Line:/
        respond_to do |format|
          format.html { redirect_to videos_path, alert: @videos.to_s.gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
        end
      else
        if @videos.to_s =~ /\*\*\*SUCCESS:\*\*\*/
          respond_to do |format|
            format.html { redirect_to videos_path, notice: @videos.to_s.gsub(/Errors have prohibited this import from completing:/, "The import file <b>#{org_file}</b> has successfully loaded").gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
          end
        else
          respond_to do |format|
            format.html { redirect_to videos_path, alert: "Errors have prohibited this import from completing:<br/>The file contains no data.".html_safe }
          end        
        end
      end
    else  
      respond_to do |format|
        format.html { redirect_to videos_path, alert: 'Select a valid csv file for import.' }
      end
    end
  end   

  # GET /videos/1
  # GET /video/1.json
  def show
    @page_title = 'Show Video'
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
    @page_title = 'Create Video Type'
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @page_title = 'Edit Video'
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])
    @video.user_id = current_user.id

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])
    @video.updated_at = Time.now

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

  private
  
    def sort_column
      Video.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
