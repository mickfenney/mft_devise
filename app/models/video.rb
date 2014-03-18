# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Video < ActiveRecord::Base

  attr_accessible :name, :code, :description, :user_id

  validates_presence_of :name, :code, :description, :user_id

  before_validation strip_attributes :except => [:user_id]

  validates_uniqueness_of :name
  validates_uniqueness_of :code
  validates_length_of :name, :maximum => 255
  validates_length_of :code, :maximum => 50
  validates_length_of :description, :maximum => 2000

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
        video = find_by_id(row["id"]) || new
        video.attributes = row.to_hash.slice(*accessible_attributes)
        if video.valid?
          video.save!
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
        select('DISTINCT videos.*') 
        .where('UPPER(videos.name) LIKE UPPER(?) or UPPER(videos.code) LIKE UPPER(?) or UPPER(videos.description) LIKE UPPER(?)', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end 

end
