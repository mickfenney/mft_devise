class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.boolean :is_map, :default => true
      t.float :latitude
      t.float :longitude
      t.integer :locatable_id
      t.string :locatable_type

      t.timestamps
    end
  end
end
