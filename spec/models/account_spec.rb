require 'spec_helper'

describe Account do
  it { should belong_to(:user) }
  it { should_not allow_mass_assignment_of(:user_id) }
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

