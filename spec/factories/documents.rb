# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    title "MyString"
    document_type_id 1
    body "MyText"
    user_id 1
  end
end
