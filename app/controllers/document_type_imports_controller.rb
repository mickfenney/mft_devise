class DocumentTypeImportsController < ApplicationController

  #load_and_authorize_resource

  def new
    @document_type_import = DocumentTypeImport.new
  end

  def create
    @document_type_import = DocumentTypeImport.new(params[:document_type_import])
    if @document_type_import.save
      redirect_to document_types_path, notice: "Imported document types successfully."
    else
      render :new
    end
  end
end