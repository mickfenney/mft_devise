# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Video < ActiveRecord::Base

  attr_accessible :name, :code, :description, :user_id

  validates_presence_of :name, :code, :description, :user_id

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_uniqueness_of :code
  validates_length_of :name, :maximum => 255
  validates_length_of :code, :maximum => 50
  validates_length_of :description, :maximum => 400

  private

    def self.search(search)
      if search
        select('DISTINCT videos.*') 
        .where('videos.name LIKE ? or videos.code LIKE ? or videos.description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end 

end
