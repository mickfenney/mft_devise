class DocumentType < ActiveRecord::Base

  attr_accessible :description, :display_name, :name, :user_id

  validates_presence_of :description, :display_name, :name, :user_id

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_uniqueness_of :display_name
  validates_length_of :name, :maximum => 255
  validates_length_of :display_name, :maximum => 255
  validates_length_of :description, :maximum => 255

  private

    def self.search(search)
      if search
        find(:all, 
             :select => 'DISTINCT document_types.*', 
             :conditions => ['document_types.name LIKE ? or document_types.display_name LIKE ? or document_types.description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"]
        )
      else
        find(:all)
      end
    end 

end
