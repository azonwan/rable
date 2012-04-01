# encoding: utf-8
class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notifications = current_user.notifications.where(:unread => true).order('created_at DESC').page(params[:page])
    @title = '提醒系统'
  end

  def all_read
    respond_to do |format|
      if current_user.notifications.update_all(:unread => false)
        format.js
      end
    end
  end

  def read
    @notification = current_user.notifications.find(params[:id])
    if @notification.update_attribute(:unread, false)
      redirect_to @notification.notifiable.notifiable_path
    else
      redirect_to root_path, :error => '无法处理之前的请求'
    end
  end
end
