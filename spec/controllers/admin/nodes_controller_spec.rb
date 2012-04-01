require 'spec_helper'

describe Admin::NodesController do
  it { should extend_the_controller(Admin::BaseController) }
  context "admins" do
    login_admin :devin
    
    before(:each) do
      @plane = Factory(:plane)
      @node = Factory(:node, :plane => @plane)
    end

    it "should show node creation form via ajax" do
      get :new, :plane_id => @plane.id, :format => :js
      should respond_with(:success)
      should assign_to(:plane)
      should assign_to(:node)
    end

    it "should create node via ajax" do
      expect {
        post :create, :plane_id => @plane.id, :node => {:key => 'rails', :name => 'Ruby on Rails'}, :format => :js
      }.should change{Node.count}.by(1)
      should respond_with(:success)
      should assign_to(:plane)
      should assign_to(:node)
    end

    it "should show node editing form via ajax" do
      get :edit, :plane_id => @plane.id, :id => @node.id, :format => :js
      should respond_with(:success)
      should assign_to(:plane)
    end

    it "should update node via ajax" do
      new_name = 'Nginx 1.0'
      put :update, :plane_id => @plane.id, :id => @node.id, :node => {:name => new_name}, :format => :js
      should respond_with(:success)
      should assign_to(:plane)
      should assign_to(:node)
      assigns(:node).name.should == new_name
    end
  end
end
