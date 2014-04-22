# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :gallery do
    name "Test Gallery"
    user_id 1
  end
end
