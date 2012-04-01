class AdvertisementSweeper < ActionController::Caching::Sweeper
  observe Advertisement

  def after_create(ad)
    expire_fragment('banner_ads') if ad.showing?
  end

  def after_update(ad)
    expire_fragment('banner_ads')
  end
end
