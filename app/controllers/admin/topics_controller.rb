# encoding: utf-8
class Admin::TopicsController < Admin::BaseController
  def index
    @topics = Topic.order('created_at DESC').page(params[:page])
    @title = '讨论主题'
  end
end
