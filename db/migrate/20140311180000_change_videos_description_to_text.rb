class ChangeVideosDescriptionToText < ActiveRecord::Migration
  def change
    change_column :videos, :description, :text
  end

end
