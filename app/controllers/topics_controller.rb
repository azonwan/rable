# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :recent, :index]
  before_filter :find_node, :except => [:show, :recent, :index]
  before_filter :find_topic_and_auth, :only => [:edit, :update]
  cache_sweeper :topic_sweeper

  def index
    respond_to do |format|
      format.html {
        @topics = Topic.order('created_at DESC').page(params[:page]).per(60)
        @title = '全站最新更改记录'
      }
      format.atom {
        @feed_items = Topic.recent_topics
        @last_update = @feed_items.first.updated_at unless @feed_items.empty?
        render :layout => false
      }
    end
  end

  def show
    @topic = Topic.find(params[:id])
    # update hit
    # FIXME: increment_counter?
    current_hit = @topic.hit
    @topic.update_column(:hit, current_hit + 1)

    @title = @topic.title
    @node = @topic.node
    @total_comments = @topic.comments.count
    @total_pages = (@total_comments * 1.0 / Settings.pagination.comments_per_topic).ceil
    @page_num = params[:p].nil? ? @total_pages : params[:p]
    @comments = @topic.comments.order('created_at ASC').page(@page_num).per(Settings.pagination.comments_per_topic)
    @new_comment = @topic.comments.new
    @total_bookmarks = @topic.bookmarks.count

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def recent
    @recent_topics = Topic.order('created_at DESC').limit(50)
    @title = '最近的 50 个主题'

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def new
    @topic = @node.topics.new

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def create
    @topic = @node.topics.build(params[:topic])
    @topic.user = current_user
    if @topic.save
      redirect_to t_path(@topic.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic])
      redirect_to t_path(@topic.id)
    else
      flash[:error] = '之前的更新有误，请编辑后再提交'
      render :edit
    end
  end

  private
    def find_node
      @node = Node.find(params[:node_id])
    end

    def find_topic_and_auth
      @topic = @node.topics.find(params[:id])
      authorize! :update, @topic, :message => '你没有权限修改此主题'
    end
end
