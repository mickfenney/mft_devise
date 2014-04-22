# == Schema Information
#
# Table name: document_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document_type do
    name "Text"
    description "MyString"
    user_id 1
  end
end
