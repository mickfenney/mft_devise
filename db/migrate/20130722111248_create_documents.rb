class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.integer :document_type_id, :default => 1
      t.text :body
      t.timestamps
    end
  end
end
