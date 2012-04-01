# configure custom format
ActionController::Responder.class_eval do
  alias :to_mobile :to_html
end

ActionMailer::Base.default_url_options[:host] = Settings.site_domain

# configure cache
ActionController::Base.cache_store = :dalli_store, *Settings.memcached.servers
