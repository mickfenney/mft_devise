class ChangeDocumentTypesDescriptionToText < ActiveRecord::Migration
  def change
    change_column :document_types, :description, :text
  end
end
