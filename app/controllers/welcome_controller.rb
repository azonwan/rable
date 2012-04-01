# encoding: utf-8
class WelcomeController < ApplicationController
  def index
    @topics = Topic.recent_topics

    respond_to do |format|
      format.html
      format.mobile { @planes = Plane.all }
    end
  end

  def goodbye
    @title = '登出'

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb @title }
    end
  end
end
