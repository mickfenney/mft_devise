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

  attr_accessible :address, :latitude, :longitude, :name, :is_map, :as => :admin
  attr_accessible :address, :latitude, :locatable_id, :locatable_type, :longitude, :name, :is_map
  validates_presence_of :address

  before_validation strip_attributes :except => [:address, :latitude, :longitude, :is_map]

  after_validation :do_geocoding

  private
    def do_geocoding
      if is_map? and :address_changed?
        locate_gecode = LocationGeocodeService.new(self[:address])
        if locate_gecode.address.nil? or locate_gecode.latitude.nil? or locate_gecode.longitude.nil?
          self[:is_map] = false
          self[:latitude]  = nil
          self[:longitude] = nil         
        else  
          self[:address]   = locate_gecode.address
          self[:latitude]  = locate_gecode.latitude
          self[:longitude] = locate_gecode.longitude
        end
      end
    end # do_geocoding method
  
end
