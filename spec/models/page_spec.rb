require 'spec_helper'

describe Page do
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should allow_mass_assignment_of(:key) }
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:content) }
  it { should allow_mass_assignment_of(:published) }
end
# == Schema Information
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean         default(FALSE)
#

