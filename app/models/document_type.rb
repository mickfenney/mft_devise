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
      @errs = ["Errors have prohibited this import from completing\n"]
      i=2
      CSV.foreach(file.path, headers: true) do |row|
        document_type = find_by_id(row["id"]) || new
        document_type.attributes = row.to_hash.slice(*accessible_attributes)
        if document_type.valid?
          document_type.save!
        else
          @errs << "Line:<b>#{i}</b> - #{row}"
        end
        i+=1
        break if i >= 50
      end
      return @errs
    end
  end

  private

    def self.search(search)
      if search 
        select('DISTINCT document_types.*')
        .where('document_types.name LIKE ? or document_types.description LIKE ?', "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end 

end
