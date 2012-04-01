class Admin::NodesController < Admin::BaseController
  before_filter :find_parent_plane
  cache_sweeper :node_sweeper

  def new
    @node = @plane.nodes.new
    respond_to do |format|
      format.js { render :show_form }
    end
  end

  def create
    @node = @plane.nodes.build(params[:node])
    respond_to do |format|
      if @node.save
        format.js { render :js => 'window.location.reload();' }
      else
        format.js { render :show_form }
      end
    end
  end

  def edit
    @node = @plane.nodes.find(params[:id])
    respond_to do |format|
      format.js { render :show_form }
    end
  end

  def update
    @node = @plane.nodes.find(params[:id])
    respond_to do |format|
      if @node.update_attributes(params[:node])
        format.js { render :js => 'window.location.reload();' }
      else
        format.js { render :show_form }
      end
    end
  end
end
