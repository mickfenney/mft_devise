class Painting < ActiveRecord::Base
	
  attr_accessible :gallery_id, :user_id, :name, :image, :remote_image_url

  belongs_to :gallery

  mount_uploader :image, ImageUploader

  before_validation strip_attributes :except => [:user_id]

  validates_presence_of :image
  #validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255  

  before_create :default_name

  after_destroy :remove_id_directory

  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end

  protected

    def remove_id_directory
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/painting/image/#{id}", :force => true)
    end    

end
