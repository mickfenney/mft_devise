# == Schema Information
#
# Table name: pictures
#
#  id         :integer          not null, primary key
#  gallery_id :integer
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

class Picture < ActiveRecord::Base
	
  attr_accessible :gallery_id, :user_id, :name, :image, :remote_image_url

  belongs_to :gallery

  mount_uploader :image, ImageUploader

  before_validation strip_attributes :except => [:user_id]

  validates_presence_of :image, :user_id, :gallery_id

  validates_length_of :name, :maximum => 255  

  before_create :default_name

  before_update :default_name

  after_destroy :remove_id_directory

  after_save :remove_tmp_directory


  def default_name
    if image.filename
      self.name ||= File.basename(image.filename, '.*').titleize if image
    else
      unless self.name
        self.name = 'Unknown'
      end
    end
  end

  protected

    def remove_id_directory
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/picture/image/#{id}", :force => true)
    end

    def remove_tmp_directory
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/tmp", :force => true)
    end     

end
