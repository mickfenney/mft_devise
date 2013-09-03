# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    name "Test Video"
    code "12345678"
    description "MyString"
    user_id 1
  end
end