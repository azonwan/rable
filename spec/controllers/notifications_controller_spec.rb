require 'spec_helper'

describe NotificationsController do
  describe "Get #index" do
    it "should redirect to sign in page for anonymous users" do
      get :index
      should respond_with(:redirect)
      should set_the_flash
      should redirect_to(new_user_session_path)
    end

    it "should not allow marking all notifications as read" do
      post :all_read, :format => :js
      should respond_with(401)
    end

    context "authenticated users" do
      login_user(:devin)
      it "should display unread notifications" do
        get :index
        should respond_with(:success)
        should assign_to(:title)
        should assign_to(:notifications)
      end

      it "should mark all notifications as read" do
        post :all_read, :format => :js
        should respond_with(:success)
      end
    end
  end
end
