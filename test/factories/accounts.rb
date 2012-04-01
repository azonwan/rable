# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    user
    introduction 'hi'
    signature 'Rails is cool'
    personal_website 'xdaqing.com'
    twitter_id 'daqing'
  end
end
# == Schema Information
#
# Table name: accounts
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  personal_website :string(255)
#  location         :string(255)
#  signature        :string(255)
#  introduction     :text
#  twitter_id       :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

