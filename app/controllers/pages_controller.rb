class PagesController < ApplicationController
  def show
    if current_user && current_user.can_manage_site?
      @page = Page.find_by_key!(params[:key])
    else
      @page = Page.only_published.find_by_key!(params[:key])
    end
    @title = @page.title
  end
end
