class PlaneSweeper < ActionController::Caching::Sweeper
  observe Plane

  def after_create(plane)
    expire_planes_nodes_cache
  end

  def after_update(plane)
    expire_planes_nodes_cache
  end

  def after_destroy(plane)
    expire_planes_nodes_cache
  end

  private
    def expire_planes_nodes_cache
      expire_fragment('nav_planes_nodes')
    end
end
