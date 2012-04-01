# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user
    association :commentable, :factory => :topic
    content 'great!'
  end
end
# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  content          :text
#  user_id          :integer
#  commentable_type :string(255)
#  commentable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#

