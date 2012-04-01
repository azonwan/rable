class Node < ActiveRecord::Base
  has_many :topics
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  belongs_to :plane

  validates :name, :plane_id, :presence => true
  validates :key, :presence => true, :uniqueness => true

  attr_accessible :name, :key, :custom_html, :introduction

  class << self
    def hot_nodes
      self.find(Topic.group('node_id').limit(20).count.keys)
    end

    def recent_nodes
      self.order('created_at DESC').limit(20)
    end
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

