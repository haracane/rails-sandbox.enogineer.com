class Blog::SiteConfig < ActiveRecord::Base
  belongs_to :site

  validates :site_id, presence: true, uniqueness: true
  validates :redirect_to, length: {maximum: 255}
end
