# encoding:utf-8
require 'carrierwave/orm/activerecord'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :email, :password, :password_confirmation, :remember_me, :avatar, :account_attributes

  mount_uploader :avatar, AvatarUploader

  validates :nickname, :presence => true, :uniqueness => true
  validate :nickname_cannot_contain_invalid_characters

  has_one :account, :dependent => :destroy
  accepts_nested_attributes_for :account
  has_many :topics, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  has_many :notifications, :dependent => :destroy

  has_many :follower_relationships, :class_name => 'Following', :foreign_key => 'followed_user_id', :dependent => :destroy
  has_many :followed_relationships, :class_name => 'Following', :foreign_key => 'user_id', :dependent => :destroy

  has_many :followers, :through => :follower_relationships
  has_many :followed_users, :through => :followed_relationships

  before_create :create_acount

  def latest_created_topics
    self.topics.order('created_at DESC').limit(10)
  end

  def latest_replied_topics
    @topic_ids ||= self.comments.select(:commentable_id).where(:commentable_type => 'Topic').collect(&:commentable_id)
    Topic.find(@topic_ids)
  end

  def bookmarked?(bookmarkable)
    bookmarkable.bookmarks.where(:user_id => self.id).count > 0
  end

  def bookmark_of(bookmarkable)
    bookmarkable.bookmarks.where(:user_id => self.id).limit(1).first
  end

  def bookmarked_nodes_count
    self.bookmarks.where(:bookmarkable_type => 'Node').count
  end

  def bookmarked_nodes
    ids = self.bookmarks.select(:bookmarkable_id).where(:bookmarkable_type => 'Node').collect(&:bookmarkable_id)
    Node.find(ids)
  end

  def bookmarked_topics_count
    self.bookmarks.where(:bookmarkable_type => 'Topic').count
  end

  def bookmarked_topics
    ids = self.bookmarks.select(:bookmarkable_id).where(:bookmarkable_type => 'Topic').collect(&:bookmarkable_id)
    Topic.find(ids)
  end

  def follow(user)
    self.followed_users << user and true
  end

  def unfollow(user)
    user.followers.delete(self) and true
  end

  def following?(user)
    self.followed_relationships.where(:followed_user_id => user.id).count > 0
  end

  def followed_by?(user)
    self.follower_relationships.where(:user_id => user.id).count > 0
  end

  def follower_count
    self.follower_relationships.count
  end

  def followed_user_count
    self.followed_relationships.count
  end

  def follower_ids
    self.follower_relationships.collect(&:user_id)
  end

  def followed_user_ids
    self.followed_relationships.collect(&:followed_user_id)
  end

  def followed_topic_timeline
    Topic.where(:user_id => self.followed_user_ids).order('created_at DESC').limit(10)
  end

  def root?
    self.id == 1 || self.role == 'root'
  end

  def admin?
    self.role == 'admin'
  end

  def acts_as_admin
    self.role = 'admin'
  end

  def acts_as_normal_user
    self.role = 'user'
  end

  def can_manage_site?
    root? || admin?
  end

  def unread_notification_count
    self.notifications.where(:unread => true).count
  end

  def html_id
    "user_#{self.id}"
  end

  private
    def create_acount
      self.build_account if self.account.nil?
    end

    def nickname_cannot_contain_invalid_characters
      if self.nickname.present? and (self.nickname.include?('@') or self.nickname.include?('-'))
        errors.add(:nickname, "不能包含@或横线等字符")
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

