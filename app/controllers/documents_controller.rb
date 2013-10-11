class DocumentsController < ApplicationController

  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Search Document'
    @documents = Document.search(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    unless  @documents.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    render 'index'
  end  

  def documents
    @documents = Document.search(params[:search]).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.csv { send_data @documents.to_csv }
    end
  end   

  def import 
    org_file = 'NoFile'
    org_file = params[:file].original_filename if params[:file].present?
    if org_file !~ /csv$/i && org_file !~ /txt$/i && params[:file].present?
      respond_to do |format|
        format.html { redirect_to documents_path, alert: "This import file <b>#{org_file}</b> is invalid, it needs to be a <b>csv</b> or a comma delimited <b>txt</b> file.".html_safe }
      end
    elsif request.post? && params[:file].present?
      @document_types = Document.import(params[:file])
      if @document_types.to_s =~ /Error Line:/
        respond_to do |format|
          format.html { redirect_to documents_path, alert: @document_types.to_s.gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
        end
      else
        if @document_types.to_s =~ /\*\*\*SUCCESS:\*\*\*/
          respond_to do |format|
            format.html { redirect_to documents_path, notice: @document_types.to_s.gsub(/Errors have prohibited this import from completing:/, "The import file <b>#{org_file}</b> has successfully loaded").gsub(/\*\*\*SUCCESS:\*\*\*/, "Success Line:").gsub(/\\n/, "").gsub(/", "/, "").gsub(/\["/, "").gsub(/"\]/, "").html_safe }
          end
        else
          respond_to do |format|
            format.html { redirect_to documents_path, alert: "Errors have prohibited this import from completing:<br/>The file contains no data.".html_safe }
          end        
        end
      end
    else  
      respond_to do |format|
        format.html { redirect_to documents_path, alert: 'Select a valid csv file for import.' }
      end
    end
  end  

  # GET /documents/1
  # GET /documents/1.json
  def show
    @page_title = 'Show Document'
    @document = Document.find(params[:id])
    if @document.is_private? and @document.user_id != current_user.id
      redirect_to root_path, alert: 'You are not authorized to access this page.'
      return
    end  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @page_title = 'Create Document'
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @page_title = 'Edit Document'
    @document = Document.find(params[:id])
    if @document.is_private? and @document.user_id != current_user.id
      redirect_to root_path, alert: 'You are not authorized to access this page.'
      return      
    end    
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document])
    @document.user_id = current_user.id

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])
    @document.updated_at = Time.now

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])

    if @document.is_private? and @document.user_id != current_user.id
      redirect_to root_path, alert: 'You are not authorized to access this page.'
      return
    end  

    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  private
  
    def sort_column
      Document.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
