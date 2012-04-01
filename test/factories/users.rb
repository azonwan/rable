# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "Rabel No.#{n}" }
    sequence(:email) { |n| "rabel_#{n}@rabel.com" }
    password Settings.default_password
    password_confirmation Settings.default_password
    after_create {|u| u.account = FactoryGirl.create(:account, :user => u)}

    factory :admin do
      role 'admin'
    end

    factory :root do
      role 'root'
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  nickname               :string(255)
#  avatar                 :string(255)
#  role                   :string(255)
#

