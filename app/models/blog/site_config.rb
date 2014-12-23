class Blog::SiteConfig < ActiveRecord::Base
  belongs_to :site, foreign_key: :blog_site_id

  validates :blog_site_id, presence: true, uniqueness: true
  validates :redirect_to, length: {maximum: 255}
end
