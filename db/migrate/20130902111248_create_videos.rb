class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :code
      t.string :description
      t.integer :user_id
      t.timestamps
    end
  end
end