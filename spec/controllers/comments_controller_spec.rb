require 'spec_helper'

describe CommentsController do
  before do
    @topic = Factory(:topic)
  end
  context "users logged out" do
    it "can't add comment" do
      expect {
        post :create, :topic_id => @topic.id, :comment => {:content => 'Great idea!'}
      }.to_not change{Comment.count}.by(1)
    end
  end

  context "users signed in" do
    login_user(:devin)
    before do
      @my_topic = Factory(:topic, :user => User.find_by_nickname(:devin))
    end

    it "can add comment" do
      expect {
        post :create, :topic_id => @topic.id, :comment => {:content => 'Great idea!'}
      }.to change{Comment.count}.by(1)
    end
  end
end
