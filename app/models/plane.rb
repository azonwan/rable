class Plane < ActiveRecord::Base
  validates :name, :presence => true
  has_many :nodes

  attr_accessible :name
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

