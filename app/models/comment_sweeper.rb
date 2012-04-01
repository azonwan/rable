class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def after_create(comment)
    expire_home_topics_cache
  end

  def after_update(comment)
    expire_home_topics_cache
  end

  private
    def expire_home_topics_cache
      expire_fragment('home_latest_topics')
    end
end
