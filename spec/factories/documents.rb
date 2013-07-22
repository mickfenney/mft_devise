# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    title "MyString"
    doc_type "text"
    body "MyText"
  end
end
