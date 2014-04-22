# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_private :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    title "MyString"
    body "MyText"
    user_id 1
  end
end
