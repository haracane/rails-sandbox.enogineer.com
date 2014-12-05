class Blog::SiteStatsGenerator
  def initialize(site)
    @site = site
  end

  def generate
    {
      title_length: @site.title.length,
      description_length: @site.description.length
    }
  end
end
