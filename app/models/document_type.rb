# == Schema Information
#
# Table name: document_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DocumentType < ActiveRecord::Base

  attr_accessible :description, :name, :user_id

  validates_presence_of :description, :name, :user_id

  has_and_belongs_to_many :documents

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 255

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
        document_type = find_by_id(row["id"]) || new
        document_type.attributes = row.to_hash.slice(*accessible_attributes)
        if document_type.valid?
          document_type.save!
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
        select('DISTINCT document_types.*')
        .where('UPPER(document_types.name) LIKE UPPER(?) or UPPER(document_types.description) LIKE UPPER(?)', "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end 

end
