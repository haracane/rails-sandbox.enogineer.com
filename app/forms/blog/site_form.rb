class Blog::SiteForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :title, String
  attribute :description, String

  #追加するvalidationがあればこのあたりに書く

  def site
    @site ||= Blog::Site.new(title: title, description: description)
  end

  def site=(site)
    @site = site
    self.title = site.title
    self.description = site.description
    @site
  end

  def persisted?
    site.persisted?
  end

  def save(user)
    site.user = user
    valid? && site.save
  end

  def valid?
    result = super
    unless site.valid?
      [:title].each do |key|
        site.errors[key].each do |error|
          errors.add(key, error)
        end
      end
      return false
    end
    return result
  end
end
