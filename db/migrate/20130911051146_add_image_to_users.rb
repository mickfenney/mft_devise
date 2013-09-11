class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :is_image, :boolean, :default => false
  end
end