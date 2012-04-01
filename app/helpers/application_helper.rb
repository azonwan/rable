# encoding: utf-8
module ApplicationHelper
  def title
    add_title_item @title if @title.present?
    @title_items.join(' - ')
  end

  def add_title_item(item)
    @title_items.unshift item
  end

  def build_navigation(items, class_name='fade')
    items.unshift(link_to(Settings.site_name, root_path))
    content = items.join(' <span class="chevron">&nbsp;›&nbsp;</span> ')
    s = <<-HTML
      <span class="#{class_name}">
      #{content}
      </span>
    HTML
    s.html_safe
  end

  def initialize_breadcrumbs_and_title
    basic_name = Settings.site_name
    basic_name += " (#{@unread_count})" if @unread_count > 0
    @title_items = [basic_name]
    @breadcrumbs = [%(<a class="black" href="#{root_path}">首页</a>)]
  end

  def add_breadcrumb(item)
    @breadcrumbs << item
  end

  def build_breadcrumbs
    result_html =
      case @breadcrumbs.length
        when 1
          @breadcrumbs.first
        else
          @breadcrumbs.join('&nbsp;›&nbsp;')
        end
    result_html.html_safe
  end

  def build_admin_navigation(items, class_name='fade')
    items.unshift(link_to('管理后台', admin_root_path))
    build_navigation(items, class_name)
  end

  def edit_topic_navigation(node, topic)
    build_navigation([
      link_to(node.name, go_path(node.key)),
      link_to(topic.title, t_path(topic.id)),
      '编辑'
    ], 'bigger')
  end

  def parse_markdown(text)
    @markdown.render(h(text)).html_safe
  end

  def mobile_view(content)
    @mobile_markdown.render(h(content)).html_safe
  end

  def flash_messages
    @flash_messages ||= flash.select {|type, message| message.length > 0}
  end

  def show_flash_messages
    result = []
    flash_messages.each do |type, message|
      result << message
    end
    result.join('<br/>').html_safe
  end

  def show_mobile_messages
    if flash_messages.any?
      content_tag(:div, show_flash_messages, :class => :cell)
    end
  end

  def search_engine_url
    Settings.search_engines[Settings.default_search_engine]
  end

  def cache_short(key, &block)
    cache(key, :expires_in => 5.minutes, &block)
  end
end
