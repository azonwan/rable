# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = '你没有权限访问刚才的页面'
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    case request.format.to_sym
    when :html, :mobile
      @title = '这个页面不存在哦~'
      @exception = exception
      render 'welcome/exception' and return
    when :js
      render :json => {:error => 'record not found'}, :status => :not_found and return
    end
  end

  rescue_from NoMethodError, RuntimeError do |exception|
    case request.format.to_sym
    when :html, :mobile
      @title = '程序遇到了麻烦!'
      @exception = exception
      logger.error @exception.message
      @exception.backtrace.each { |line| logger.error line }
      render 'welcome/exception' and return
    when :js
      render :json => {:error => 'internal server error'}, :status => :internal_server_error and return
    end
  end

  before_filter :initialize_markdown
  before_filter :count_unread_notification
  before_filter :detect_mobile_client
  before_filter :initialize_breadcrumbs_and_title

  def custom_path(model)
    if model.is_a? Topic
      t_path(model.id)
    elsif model.is_a? Node
      go_path(model.key)
    else
      model
    end
  end

  def method_missing(method, *args, &block)
    if method =~ /^find_(.*)able/
      such_able = "@#{$1}able"
      params.each do |name, value|
        if name =~ /(.+)_id$/
          instance_variable_set(such_able.to_sym, $1.classify.constantize.find(value)) and return
        end
      end
    else
      super
    end
  end

  def initialize_markdown
    @markdown = Redcarpet::Markdown.new(Rabel::Base::Render,
                                        :no_intra_emphasis => true,
                                        :fenced_code_blocks => true,
                                        :autolink => true,
                                        :strikethrough => true,
                                        :filter_html => true,
                                        :space_after_headers => true,
                                       )

    @mobile_markdown = Redcarpet::Markdown.new(Rabel::CustomMobileRender,
                                        :no_intra_emphasis => true,
                                        :fenced_code_blocks => true,
                                        :autolink => true,
                                        :strikethrough => true,
                                        :filter_html => true,
                                        :space_after_headers => true,
                                       )
  end

  def mobile_device?
    request.format == :mobile
  end

  private
    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      goodbye_path
    end

    def count_unread_notification
      @unread_count = current_user.try(:unread_notification_count) || 0
    end

    # From Teambox
    def detect_mobile_client
      if [:html, :mobile].include?(request.format.try(:to_sym)) and session[:format]
        # Format has been forced by Sessions#change_format
        request.format = session[:format].to_sym
      else
        # We should autodetect mobile clients and redirect if they ask for html
        mobile_regex = /(iPhone|iPod|Android|Opera mini|Opera mobi|Blackberry|Palm|UCWEB|Windows CE|PSP|Blazer|iemobile|webOS)/i
        mobile =   request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][mobile_regex]
        mobile ||= request.env["HTTP_PROFILE"] || request.env["HTTP_X_WAP_PROFILE"]
        if mobile and request.format == :html
          request.format = :mobile
        end
      end
    end
end

