# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  address        :string(255)
#  is_map         :boolean          default(TRUE)
#  latitude       :float
#  longitude      :float
#  locatable_id   :integer
#  locatable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Location < ActiveRecord::Base

  belongs_to :locatable, :polymorphic => true

  attr_accessible :address, :latitude, :locatable_id, :locatable_type, :longitude, :name, :is_map
  validates_presence_of :address

  before_validation strip_attributes :except => [:address, :latitude, :longitude, :is_map]

  geocoded_by :address
  after_validation :geocode, :if => :do_geocoding?

  def address=(address_string)
    if address_string.is_a?(String)
      locate_gecode = LocationGeocode.new(address_string)
      if locate_gecode.address.nil?
        @is_map = false
        super(address_string) 
      else  
        super(locate_gecode.address)
      end
    end  
  end

  private
    def do_geocoding?
      if is_map?
        return :address_changed?
      else
        return false
      end
    end # do_geocoding? method
  
end
