class Blog::SiteObserver < ActiveRecord::Observer
  def after_create(site)
    site.logger.info('New site added')
  end
end
