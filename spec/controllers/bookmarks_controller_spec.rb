require 'spec_helper'

describe BookmarksController do
  before do
    @node = Factory(:node)
    @topic = Factory(:topic)
  end

  context "anonymous users" do
    it "should not create bookmark" do
      expect {
        post :create, :topic_id => @topic.id,
      }.should_not change{Bookmark.count}.by(1)

      should respond_with(:redirect)
      should set_the_flash
      should_not assign_to(:bookmarkable)
    end

    it "should not destroy bookmark" do
      @bookmark = Factory(:bookmark)
      expect {
        delete :destroy, :id => @bookmark.id
      }.should_not change{Bookmark.count}.by(-1)

      should respond_with(:redirect)
      should set_the_flash
      should_not assign_to(:bookmark)
    end
  end

  context "authenticated users" do
    login_user(:devin)
    it "should create bookmark" do
      expect {
        post :create, :topic_id => @topic.id,
      }.should change{Bookmark.count}.by(1)

      should respond_with(:redirect)
      should assign_to(:bookmarkable)
      should_not set_the_flash
    end

    it "should destroy his/her own bookmark" do
      @bookmark = Factory(:bookmark, :user => User.find_by_nickname(:devin))

      expect {
        delete :destroy, :id => @bookmark.id
      }.should change{Bookmark.count}.by(-1)

      should respond_with(:redirect)
      should_not set_the_flash
      should assign_to(:bookmark)
    end

    it "should not destroy other's bookmark" do
      nana = Factory(:user, :nickname => 'nana')
      @bookmark = Factory(:bookmark, :user => nana)

      expect {
        delete :destroy, :id => @bookmark.id
      }.should_not change{Bookmark.count}.by(-1)

      should respond_with(:redirect)
      should redirect_to(root_path)
      should set_the_flash
      should assign_to(:bookmark)
    end
  end
end
