# encoding: utf-8
class Admin::PlanesController < Admin::BaseController
  before_filter :find_plane, :only => [:edit, :update, :destroy]
  cache_sweeper :plane_sweeper

  def index
    @planes = Plane.order('created_at ASC').all
    @title = '位面/节点'
  end

  def new
    @plane = Plane.new
    respond_to do |format|
      format.js { render :show_form }
    end
  end

  def create
    @plane = Plane.new(params[:plane])
    respond_to do |format|
      if @plane.save
        format.js { render :js => 'window.location.reload()' }
      else
        format.js { render :show_form }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :show_form }
    end
  end

  def update
    respond_to do |format|
      if @plane.update_attributes(params[:plane])
        format.js { render :js => 'window.location.reload()' }
      else
        format.js { render :show_form }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @plane.destroy
        format.js { render :js => 'window.location.reload()' }
      else
        format.js { render :json => {:error => 'delete plane failed'}, :status => :unprocessable_entity }
      end
    end
  end
end
