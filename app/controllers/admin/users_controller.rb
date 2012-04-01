# encoding: utf-8
class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order('created_at DESC').page(params[:page])
    @title = '用户'
  end

  def toggle_admin
    respond_to do |format|
      if current_user.root?
        @user = User.find(params[:id])
        if @user.admin?
          @user.acts_as_normal_user
        else
          @user.acts_as_admin
        end
        if @user.save
          format.js
        else
          format.js { render :json => {:error => 'toggle admin failed'}, :status => :unprocessable_entity }
        end
      else
        format.js { render :json => {:error => 'no permission'}, :status => :forbidden }
      end
    end
  end
end
