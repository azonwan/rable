# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node do
    sequence(:name) { |n| "Node - #{n}" }
    sequence(:key) { |n| "key_#{n}" }
    introduction('this is a small node')
    custom_html(%(<span class="fade">hi</span>))
    plane
  end
end
# == Schema Information
#
# Table name: nodes
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  key          :string(255)
#  introduction :string(255)
#  custom_html  :text
#  created_at   :datetime
#  updated_at   :datetime
#  plane_id     :integer
#

