class NodeSweeper < ActionController::Caching::Sweeper
  observe Node

  def after_create(node)
    expire_planes_nodes_cache
  end

  def after_update(node)
    expire_planes_nodes_cache
  end

  private
    def expire_planes_nodes_cache
      expire_fragment('nav_planes_nodes')
    end
end
