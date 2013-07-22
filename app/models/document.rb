class Document < ActiveRecord::Base

  attr_accessible :body, :doc_type, :title

  enumerate :doc_type, :with => DocumentEnum

  validates_presence_of :title, :doc_type, :body

  validates :title, :length => { :maximum => 255 }
  validates_length_of :body, :maximum => 50000
  validates_inclusion_of :doc_type, :in => DocumentEnum

  private

    def self.search(search)
      if search
        find(:all, 
             :select => 'DISTINCT documents.*', 
             :conditions => ['documents.title LIKE ? or documents.doc_type LIKE ? or documents.body LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"]
        )
      else
        find(:all)
      end
    end 

end
