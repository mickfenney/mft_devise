# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_private :boolean          default(FALSE)
#

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

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    if file.present?
      @errs = ["<table class='table table-striped table-bordered table-condensed'><tr><td>Errors have prohibited this import from completing:</td></tr>"]
      i=2
      CSV.foreach(file.path, headers: true) do |row|
        document = find_by_id(row["id"]) || new
        document.attributes = row.to_hash.slice(*accessible_attributes)
        unless document.id.present?
          document.document_type_ids = [1]
        end
        if document.valid?
          document.save!
          @errs << "<tr style='background-color:#99FF99; color:green;'><td>***SUCCESS:***<b>#{i}</b> - #{row}</td></tr>"
        else
          @errs << "<tr><td>Error Line:<b>#{i}</b> - #{row}</td></tr>"
        end
        i+=1
        break if i >= 100
      end
      @errs << "</table>"
      return @errs
    end
  end  

  private

    def self.search(search)
      if search
        select('DISTINCT d.*')
        .from('documents d, document_types_documents dtd, document_types dt')
        .where('d.id = dtd.document_id and dtd.document_type_id = dt.id and (d.title LIKE ? or dt.name LIKE ? or d.body LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end 

end
