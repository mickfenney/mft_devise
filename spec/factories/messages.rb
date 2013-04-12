# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    name "From User"
    email "from@example.com"
    content "This is a test message for mfTechnology"
  end
end
