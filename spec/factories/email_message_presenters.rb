# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_message_presenter do
    name "From User"
    email "from@example.com"
    content "This is a test message for #{ENV["SITE_NAME"]}"
  end
end
