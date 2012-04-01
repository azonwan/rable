# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    user
    node
    title 'Hello'
    content 'Hello, world'

    factory :locked_topic do
      created_at Time.now - Topic::EDITABLE_PERIOD
    end
  end
end
# == Schema Information
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  node_id    :integer
#  user_id    :integer
#  title      :string(255)
#  content    :text
#  hit        :integer
#  created_at :datetime
#  updated_at :datetime
#

