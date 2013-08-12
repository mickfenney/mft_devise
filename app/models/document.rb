class Document < ActiveRecord::Base

  attr_accessible :body, :document_type_ids, :title, :user_id, :is_private

  validates_presence_of :title, :body, :user_id
  validates_presence_of :document_type_ids, :message => "please select one"

  belongs_to :user

  has_and_belongs_to_many :document_types

  before_validation strip_attributes :except => [:document_type_ids, :user_id, :is_private]

  validates :title, :length => { :maximum => 255 }
  validates_length_of :body, :maximum => 50000
  
  #validates_inclusion_of :document_type_id, :in => Proc.new { DocumentType.all.collect(&:id) }
  #validates_inclusion_of :user_id, :in => Proc.new { User.all.collect(&:id) }
  # validate :document_type_exists

  # protected

  # def document_type_exists
  #   ids = [DocumentType.all.map(&:id)]
  #   if !document_type_id.blank? && !ids.member?(document_type_id)
  #     errors.add(:document_type_id, "does not point to a valid doc type record")
  #   end
  # end  

  private

    def self.search(search)
      if search
        find(:all, 
             :select => 'DISTINCT d.*', 
             :from => 'documents d, document_types_documents dtd, document_types dt', 
             :conditions => ['d.id = dtd.document_id and dtd.document_type_id = dt.id and (d.title LIKE ? or dt.name LIKE ? or d.body LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%"],
             :order => 'updated_at DESC'
        )
      else
        find(:all)
      end
    end 

end
