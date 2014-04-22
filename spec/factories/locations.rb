# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  address        :string(255)
#  is_map         :boolean          default(TRUE)
#  latitude       :decimal(20, 15)
#  longitude      :decimal(20, 15)
#  locatable_id   :integer
#  locatable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "Home"
    address "75 Seaview Avenue, Safety Beach VIC 3936, Australia"
    is_map true
    latitude -38.31199
    longitude 144.996326
    locatable_id 1
    locatable_type "User"
  end
end
