
class ChangeLocationsPrecision < ActiveRecord::Migration

  def change

    change_column :locations, :latitude, :decimal, :precision => 20, :scale => 15

    change_column :locations, :longitude, :decimal, :precision => 20, :scale => 15

  end

end
