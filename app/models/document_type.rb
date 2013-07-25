class DocumentType < ActiveRecord::Base

  attr_accessible :description, :name, :user_id

  validates_presence_of :description, :name, :user_id

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 255

  private

    def self.search(search)
      if search
        find(:all, 
             :select => 'DISTINCT document_types.*', 
             :conditions => ['document_types.name LIKE ? or document_types.description LIKE ?', "%#{search}%", "%#{search}%"]
        )
      else
        find(:all)
      end
    end 

end
