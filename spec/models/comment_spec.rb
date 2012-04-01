require 'spec_helper'

describe Comment do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:commentable_id) }
  it { should validate_presence_of(:commentable_type) }
  it { should validate_presence_of(:content) }
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:commentable_id) }
  it { should_not allow_mass_assignment_of(:commentable_type) }
  context "an instance" do
    it "should have mentions" do
      c = Factory(:comment, :content => '@daqing hi')
      c.has_mentions?.should be_true
    end

    it "should mention existing user" do
      nickname = 'nana'
      user = Factory(:user, :nickname => nickname)
      c = Factory(:comment, :content => "@#{nickname} hi")
      c.mentioned_users.include?(user).should be_true
    end

    it "mentioned users should not contain the commenter" do
      user = Factory(:user)
      c = Factory(:comment, :user => user, :content => "@#{user.nickname} hi")
      c.mentioned_users.include?(user).should_not be_true
    end

    it "mentioned users should not contain the commentable creator" do
      topic = Factory(:topic)
      c = Factory(:comment, :commentable => topic, :content => "@#{topic.user.nickname} hi")
      c.mentioned_users.include?(topic.user).should_not be_true
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

