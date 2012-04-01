# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def show
    @user = User.find_by_nickname!(params[:nickname])
    @title = @user.nickname
    @signature = @user.account.signature
    @twitter_id = @user.account.twitter_id
    @personal_website = @user.account.personal_website
    @location = @user.account.location
    @introduction = @user.account.introduction

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb @user.nickname }
    end
  end

  def edit
    @user = current_user
    @user.build_account unless @user.account.present?
    @title = '设置'

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def update_account
    @user = current_user
    if @user.update_without_password(params[:user])
      flash[:success] = '个人设置成功更新'
      sign_in :user, current_user, :bypass => true
      redirect_to settings_path
    else
      flash[:error] = '个人设置保存失败'
      render :edit
    end
  end

  def update_password
    @user = current_user
    if @user.update_with_password(params[:user])
      flash[:success] = '密码已成功更新，下次请用新密码登录'
      sign_in :user, current_user, :bypass => true
      redirect_to settings_path
    else
      flash[:error] = '密码更新失败'
      render :edit
    end
  end

  def update_avatar
    @user = current_user
    if @user.update_without_password(params[:user])
      flash[:success] = '头像更新成功'
      redirect_to settings_path
    else
      flash[:error] = '头像更新失败'
      render :edit
    end
  end

  def my_nodes
    @my_nodes = current_user.bookmarked_nodes
    @title = '我收藏的节点'
  end

  def my_topics
    @my_topics = current_user.bookmarked_topics
    @title = '我收藏的主题'
  end

  def my_following
    @my_followed_users = current_user.followed_users
    @followed_topic_timeline = current_user.followed_topic_timeline
    @title = '我的特别关注'
  end

  def follow
    @followed_user = User.find_by_nickname!(params[:nickname])
    unless current_user.following?(@followed_user)
      flash[:error] = '加入特别关注失败' unless current_user.follow(@followed_user)
    end
    redirect_to member_path(params[:nickname])
  end

  def unfollow
    @followed_user = User.find_by_nickname!(params[:nickname])
    if current_user.following?(@followed_user)
      flash[:error] = '取消特别关注失败' unless current_user.unfollow(@followed_user)
    end
    redirect_to member_path(params[:nickname])
  end
end
