class Topic < ActiveRecord::Base
  include Notifiable
  DEFAULT_HIT = 0
  EDITABLE_PERIOD = 5.minutes
  belongs_to :node
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy

  validates :node_id, :user_id, :title, :presence => true
  attr_accessible :title, :content

  after_initialize :set_default_hit

  def last_comment
    self.comments.order('created_at ASC').last
  end

  def locked?
    Time.now - self.created_at > Topic::EDITABLE_PERIOD
  end

  def allow_modification_by?(user)
    (!locked? && self.user == user) || user.can_manage_site?
  end

  def notifiable_title
    title
  end

  def notifiable_path
    "/t/#{id}"
  end

  class << self
    def recent_topics
      self.order('updated_at DESC').limit(15)
    end
  end

  private
    def set_default_hit
      self.hit ||= DEFAULT_HIT
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

