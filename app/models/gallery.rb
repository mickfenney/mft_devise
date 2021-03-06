# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Gallery < ActiveRecord::Base

  attr_accessible :name, :user_id

  validates_presence_of :name, :user_id

  has_many :pictures

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255

  after_destroy :remove_id_directory

  protected

    def remove_id_directory
    	@dirs = Picture.where('gallery_id' => id)
      for dir in @dirs
      	FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/picture/image/#{dir.id}", :force => true)
      end
      Picture.destroy_all('gallery_id' => id)    
    end  

  private

    def self.search(search)
      if search
        select('DISTINCT galleries.*')
        .where('UPPER(galleries.name) LIKE UPPER(?)', "%#{search}%")
      else
        scoped
      end
    end     

end
