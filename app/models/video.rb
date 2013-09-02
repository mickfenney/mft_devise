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
        find(:all, 
             :select => 'DISTINCT videos.*', 
             :conditions => ['videos.name LIKE ? or videos.code LIKE ? or videos.description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"]
        )
      else
        find(:all)
      end
    end 

end