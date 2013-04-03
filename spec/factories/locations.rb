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
