require 'spec_helper'

describe TopicsController do
  before do
    @node = Factory(:node)
    @topic = Factory(:topic, :node => @node)
    @topic_params = {:title => 'hi', :content => 'Rails is cool'}
  end

  it "should show topic" do
    get :show, :id => @topic.id
    should respond_with(:success)
    should assign_to(:topic)
    should assign_to(:title)
    should assign_to(:node)
    should assign_to(:total_comments)
    should assign_to(:total_pages)
    should assign_to(:page_num)
    should assign_to(:comments)
    should assign_to(:new_comment)
    should assign_to(:total_bookmarks)
  end

  it "should show topic in mobile version" do
    get :show, :id => @topic.id, :format => :mobile
    should respond_with(:success)
  end

  it "should show recent topics" do
    get :recent
    should respond_with(:success)
    should assign_to(:recent_topics)
    should assign_to(:title)
  end

  it "should show recent topics in mobile version" do
    get :recent, :format => :mobile
    should respond_with(:success)
  end

  it "should show all topics" do
    get :index
    should respond_with(:success)
    should assign_to(:topics)
    should assign_to(:title)
  end

  it "should show atom feed" do
    get :index, :format => :atom
    should respond_with(:success)
    should assign_to(:feed_items)
  end

  context "anonymous users" do
    it "should redirect when trying to create topic" do
      expect {
        post :create, :node_id => @node.id, :topic => @topic_params
      }.to_not change{Topic.count}.by(1)
      should respond_with(:redirect)
    end

    it "should redirect when trying to edit topic" do
      get :edit, :node_id => @node.id, :id => @topic.id
      should respond_with(:redirect)
      should_not assign_to(:topic)
    end

    it "should redirect when visit topic creation form" do
      get :new, :node_id => @node.id
      should respond_with(:redirect)
      should_not assign_to(:topic)
    end
    it "should redirect when updating topic" do
      post :update, :node_id => @node.id, :id => @topic.id, :topic => @topic_params
      should respond_with(:redirect)
      should_not assign_to(:node)
      should_not assign_to(:topic)
    end
  end

  context "authenticated users" do
    login_user(:devin)
    before(:each) do
      @current_user = User.find_by_nickname(:devin)
      @my_topic = Factory(:topic, :node => @node, :user => @current_user)
    end

    it "can create topic" do
      expect {
        post :create, :node_id => @node.id, :topic => @topic_params
      }.to change{Topic.count}.by(1)
      should respond_with(:redirect)
    end

    it "can create topic without content" do
      expect {
        post :create, :node_id => @node.id, :topic => {:title => 'hi'}
      }.to change{Topic.count}.by(1)
      should respond_with(:redirect)
    end

    it "can edit topic" do
      get :edit, :node_id => @node, :id => @my_topic.id
      should respond_with(:success)
      should assign_to(:node)
      should assign_to(:topic)
    end

    it "should display topic creation form" do
      get :new, :node_id => @node.id
      should respond_with(:success)
      should assign_to(:node)
      should assign_to(:topic)
    end

    it "should display topic creation form in mobile version" do
      get :new, :node_id => @node.id, :format => :mobile
      should respond_with(:success)
    end

    it "can only edit own topics" do
      nana = Factory(:user)
      others_topic = Factory(:topic, :user => nana, :node => @node)
      get :edit, :node_id => @node, :id => others_topic.id
      should respond_with(:redirect)
      should assign_to(:node)
      should assign_to(:topic)
    end

    it "can't update others topic" do
      post :update, :node_id => @node.id, :id => @topic.id, :topic => @topic_params
      should respond_with(:redirect)
      should assign_to(:node)
      should assign_to(:topic)
      should set_the_flash
    end

    it "can't update locked topic" do
      locked_topic = Factory(:locked_topic, :user => @current_user, :node => @node)

      post :update, :node_id => @node.id, :id => locked_topic.id, :topic => @topic_params
      should respond_with(:redirect)
      should redirect_to(root_path)
      should set_the_flash
      should assign_to(:topic)
      assigns(:topic).title.should_not == @topic_params[:title]
    end

    it "can update created topics when it's not locked" do
      post :update, :node_id => @node.id, :id => @my_topic.id, :topic => @topic_params
      should assign_to(:node)
      should assign_to(:topic)
      should respond_with(:redirect)
      should redirect_to(t_path(@my_topic.id))
      should_not set_the_flash
    end
  end

  context "admins" do
    login_admin :devin
    before(:each) do
      @current_user = User.find_by_nickname(:devin)
      @locked_topic = Factory(:locked_topic, :node => @node)
    end

    it "can edit locked topics" do
      get :edit, :node_id => @node, :id => @locked_topic.id
      should respond_with(:success)
      should assign_to(:topic)
      should assign_to(:node)
    end

    it "can update locked topics" do
      post :update, :node_id => @node.id, :id => @locked_topic.id, :topic => @topic_params
      should assign_to(:node)
      should assign_to(:topic)
      should respond_with(:redirect)
      should redirect_to(t_path(@locked_topic.id))
      should_not set_the_flash
    end
  end
end

