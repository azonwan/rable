# encoding: utf-8
class Page < ActiveRecord::Base
  validates :key, :title, :content, :presence => true

  attr_accessible :key, :title, :content, :published

  def self.only_published
    where(:published => true)
  end

  def self.default_order
    order('id ASC')
  end
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

