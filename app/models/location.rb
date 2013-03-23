class Location < ActiveRecord::Base

  belongs_to :locatable, :polymorphic => true

  attr_accessible :address, :latitude, :locatable_id, :locatable_type, :longitude, :name, :is_map
  validates_presence_of :address

  before_validation strip_attributes :except => [:latitude, :longitude, :is_map]

  geocoded_by :address
  after_validation :geocode, :if => :do_geocoding?

  private
    def do_geocoding?
      if is_map?
        return :address_changed?
      else
        return false
      end
    end # do_geocoding? method
  
end
