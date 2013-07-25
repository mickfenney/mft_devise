# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document_type do
    name "Text"
    description "MyString"
    user_id 1
  end
end
