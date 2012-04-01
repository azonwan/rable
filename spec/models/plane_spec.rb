require 'spec_helper'

describe Plane do
  it { should validate_presence_of(:name) }
  it { should have_many(:nodes) }
  it { should_not have_many(:nodes).dependent(:destroy) }
end
# == Schema Information
#
# Table name: planes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

