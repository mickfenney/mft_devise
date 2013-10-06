class DocumentTypeImport
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_document_types.map(&:valid?).all?
      imported_document_types.each(&:save!)
      true
    else
      self.imported_document_types.each_with_index do |document_type, index|
        document_type.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_document_types
    @imported_document_types ||= load_imported_document_types
  end

  def load_imported_document_types
    CSV.foreach(file.path, headers: true) do |row|
      document_type = DocumentType.find_by_id(row["id"]) || DocumentType.new
      document_type.attributes = row.to_hash.slice(*DocumentType.accessible_attributes)
      document_type.save!
    end
  end

  # def load_imported_document_types
  #   spreadsheet = open_spreadsheet
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).map do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     document_type = DocumentType.find_by_id(row["id"]) || DocumentType.new
  #     document_type.attributes = row.to_hash.slice(*DocumentType.accessible_attributes)
  #     document_type.save!
  #   end
  # end

  # def open_spreadsheet
  #   case File.extname(file.original_filename)
  #   when ".csv" then Csv.new(file.path, nil, :ignore)
  #   when ".xls" then Excel.new(file.path, nil, :ignore)
  #   when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  #   else raise "Unknown file type: #{file.original_filename}"
  #   end
  # end  

end