require 'spec_helper'

describe Admin::UsersController do
  it { should extend_the_controller(Admin::BaseController) }
  before(:each) do
    @user = Factory(:user)
  end

  context "admins" do
    login_admin :devin

    it "should list all users" do
      get :index
      should respond_with(:success)
      should assign_to(:users)
      should assign_to(:title)
    end

    it "can't manage permissions" do
      post :toggle_admin, :id => @user.id, :format => :js
      should respond_with(:forbidden)
    end
  end

  context "root" do
    login_as_root
    it "should toggle admin" do
      post :toggle_admin, :id => @user.id, :format => :js
      should respond_with(:success)
      should assign_to(:user)
      assigns(:user).admin?.should be_true
    end
  end
end
