# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_commentable
  cache_sweeper :comment_sweeper

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    flash[:else] = '添加回复失败' unless @comment.save
    redirect_to custom_path(@commentable)
  end
end
