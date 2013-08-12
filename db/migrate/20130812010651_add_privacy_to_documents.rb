class AddPrivacyToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :is_private, :boolean, :default => false
  end
end
