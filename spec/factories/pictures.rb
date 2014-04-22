# == Schema Information
#
# Table name: pictures
#
#  id         :integer          not null, primary key
#  gallery_id :integer
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    name "Test Picture"
    #image "test_image.jpg"
    remote_image_url "https://www.google.com.au/images/srpr/logo4w.png"
    gallery_id 1
    user_id 1
  end
end
