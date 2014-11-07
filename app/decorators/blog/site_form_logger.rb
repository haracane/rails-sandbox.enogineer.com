class Blog::SiteFormLogger < ModelDecorator
  alias :site_form :object

  def save(*argv)
    if site_form.save(*argv)
      site_form.site.logger.info("Created a site")
      true
    else
      site_form.site.logger.error("Failed to create a site")
      false
    end
  end
end
