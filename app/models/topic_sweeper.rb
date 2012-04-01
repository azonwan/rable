class TopicSweeper < ActionController::Caching::Sweeper
  observe Topic

  def after_create(topic)
    expire_home_topics_cache
  end

  def after_update(topic)
    expire_home_topics_cache
  end

  private
    def expire_home_topics_cache
      expire_fragment('home_latest_topics')
    end
end
