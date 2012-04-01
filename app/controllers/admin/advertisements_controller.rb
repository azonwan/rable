# encoding: utf-8
class Admin::AdvertisementsController < Admin::BaseController
  cache_sweeper :advertisement_sweeper

  def index
    @ads = Advertisement.order('start_date DESC').page(params[:page]).per(4)
    @title = '广告位'
  end

  def new
    @ad = Advertisement.new
    @title = '添加新广告'
  end

  def create
    @ad = Advertisement.new(params[:advertisement])
    if @ad.save
      redirect_to admin_advertisements_path
    else
      flash[:error] = '添加新广告失败'
      render :new
    end
  end

  def edit
    @ad = Advertisement.find(params[:id])
    @title = '修改广告'
  end

  def update
    @ad = Advertisement.find(params[:id])
    if @ad.update_attributes(params[:advertisement])
      redirect_to admin_advertisements_path
    else
      flash[:error] = '修改广告失败'
      render :edit
    end
  end
end
