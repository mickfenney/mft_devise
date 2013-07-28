class DocumentTypesDocuments < ActiveRecord::Migration
  def change
  	create_table :document_types_documents, :id => false do |t|
  		t.integer :document_type_id
  		t.integer :document_id
    end
    add_index :document_types_documents, [:document_type_id, :document_id], :name => 'doctypes_docs'
  end
end
