require 'spec_helper'

describe Admin::AdvertisementsController do
  it { should extend_the_controller(Admin::BaseController) }

  context "admins" do
    login_admin :devin

    before(:each) do
      @ad = Factory(:advertisement)
    end

    it "should show all ads" do
      get :index
      should respond_with(:success)
      should assign_to(:ads)
    end

    it "should show ad creation form" do
      get :new
      should respond_with(:success)
      should assign_to(:ad)
    end

    it "should show ad editing form" do
      get :edit, :id => @ad.id
      should respond_with(:success)
      should assign_to(:ad)
    end

    it "should update ad" do
      new_title = 'Rabel 1.0 Preview'
      post :update, :id => @ad.id, :advertisement => {:title => new_title}
      should respond_with(:redirect)
      should_not set_the_flash
      should assign_to(:ad)
      assigns(:ad).title.should == new_title
    end
  end
end
