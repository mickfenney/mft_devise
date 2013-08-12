class DocumentTypesController < ApplicationController
  
  load_and_authorize_resource

  def index
    @page_title = 'Search Document Type'
    @document_types = DocumentType.page(params[:page]).order("name ASC").per_page(10).search(params[:search])
    unless  @document_types.any?
      flash.now[:info] = "Your search for '<b>#{params[:search]}</b>' did not return any results".html_safe
    end  
    render 'index'
  end    

  # GET /document_types/1
  # GET /document_types/1.json
  def show
    @page_title = 'Show Document Type'
    @document_type = DocumentType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document_type }
    end
  end

  # GET /document_types/new
  # GET /document_types/new.json
  def new
    @page_title = 'Create Document Type'
    @document_type = DocumentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document_type }
    end
  end

  # GET /document_types/1/edit
  def edit
    @page_title = 'Edit Document'
    @document_type = DocumentType.find(params[:id])
  end

  # POST /document_types
  # POST /document_types.json
  def create
    @document_type = DocumentType.new(params[:document_type])
    @document_type.user_id = current_user.id

    respond_to do |format|
      if @document_type.save
        format.html { redirect_to @document_type, notice: 'Document type was successfully created.' }
        format.json { render json: @document_type, status: :created, location: @document_type }
      else
        format.html { render action: "new" }
        format.json { render json: @document_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /document_types/1
  # PUT /document_types/1.json
  def update
    @document_type = DocumentType.find(params[:id])
    @document_type.updated_at = Time.now

    respond_to do |format|
      if @document_type.update_attributes(params[:document_type])
        format.html { redirect_to @document_type, notice: 'Document type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_types/1
  # DELETE /document_types/1.json
  def destroy
    @document_type = DocumentType.find(params[:id])
    @document_type.destroy

    respond_to do |format|
      format.html { redirect_to document_types_url }
      format.json { head :no_content }
    end
  end
end
