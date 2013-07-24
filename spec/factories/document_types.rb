# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document_type do
    name "text"
    display_name "MyString"
    description "MyString"
    user_id 1
  end
end
