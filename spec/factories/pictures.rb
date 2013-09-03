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