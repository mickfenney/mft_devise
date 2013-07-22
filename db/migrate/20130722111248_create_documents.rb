class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.string :doc_type, :default => "text"
      t.text :body
      t.timestamps
    end
  end
end
