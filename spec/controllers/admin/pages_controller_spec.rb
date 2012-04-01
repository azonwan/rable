require 'spec_helper'

describe Admin::PagesController do
  it { should extend_the_controller(Admin::BaseController) }
  context "admins" do
    login_admin(:devin)

    before(:each) do
      @page = Factory(:page)
    end

    it "should display all pages" do
      get :index
      should assign_to(:pages)
      should assign_to(:title)
      should respond_with(:success)
    end

    it "should display page creation form" do
      get :new
      should assign_to(:page)
      should assign_to(:title)
      should respond_with(:success)
    end

    it "should create page" do
      expect {
        post :create, :page => {:key => 'foo', :title => 'hi', :content => 'ok'}
      }.should change{Page.count}.by(1)

      should assign_to(:page)
      should respond_with(:redirect)
      should_not set_the_flash
    end

    it "should edit page" do
      get :edit, :id => @page.id
      should assign_to(:page)
      should assign_to(:title)
      should respond_with(:success)
    end

    it "should update page" do
      post :update, :id => @page.id, :page => {:title => 'hello'}
      should assign_to(:page)
      should respond_with(:redirect)
      should_not set_the_flash
    end

    it "should delete page" do
      expect {
        delete :destroy, :id => @page.id
      }.should change{Page.count}.by(-1)

      should respond_with(:redirect)
      should_not set_the_flash
    end
  end
end
