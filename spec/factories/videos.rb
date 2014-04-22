# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    name "Test Video"
    code "12345678"
    description "MyString"
    user_id 1
  end
end
