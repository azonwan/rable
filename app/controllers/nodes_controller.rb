class NodesController < ApplicationController
  def show
    @node = Node.find_by_key!(params[:key])
    @title = @node.name
    @page_num = params[:p].nil? ? 1 : params[:p].to_i
    @total_topics = @node.topics.count
    @total_pages = (@total_topics * 1.0 / Settings.pagination.topics_per_node).ceil
    @next_page_num = (@page_num < @total_pages) ? @page_num + 1 : 0
    @prev_page_num = (@page_num > 1) ? @page_num - 1 : 0
    @topics = @node.topics.order('created_at DESC').page(@page_num).per(Settings.pagination.topics_per_node)

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb @node.name }
    end
  end
end
