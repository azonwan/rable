class Comment < ActiveRecord::Base
  MENTION_REGEXP = /@(\p{Word}+)/u

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates :user_id, :commentable_id, :commentable_type, :content, :presence => true
  attr_accessible :content

  after_create :touch_parent_model
  after_create :send_notifications

  def has_mentions?
    self.content =~ MENTION_REGEXP
  end

  def mentioned_users
    mentioned_names = self.content.scan(MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(self.user.nickname)
    mentioned_names.delete(self.commentable.user.nickname)
    mentioned_names.map { |name| User.find_by_nickname(name) }.compact
  end

  private
    def touch_parent_model
      self.commentable.touch
    end

    def send_notifications
      # send notification to commentable owner
      # unless the comment was created by the same owner
      send_notification_to(
        self.commentable.user,
        Notification::ACTION_REPLY) unless self.user == self.commentable.user
      send_notification_to_mentioned_users if self.has_mentions?
    end

    def send_notification_to(user, action)
      Notification.notify(
        user,
        self.commentable,
        self.user,
        action,
        self.content
      )
    end

    def send_notification_to_mentioned_users
      mentioned_users.each do |user|
        send_notification_to(user, Notification::ACTION_MENTION)
      end
    end
end
# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  content          :text
#  user_id          :integer
#  commentable_type :string(255)
#  commentable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#

