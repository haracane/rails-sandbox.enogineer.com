class Blog::Site < ActiveRecord::Base
  belongs_to :user
  has_one :site_config, foreign_key: :blog_site_id
  has_many :posts, foreign_key: :blog_site_id

  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 128}, uniqueness: {scope: :user_id}
  validates :description, presence: true
  validates_with Blog::SiteDescriptionSignificanceValidator

  before_save Blog::SiteLanguageEstimator.new(:language)

  def rating
    @rating ||= Blog::SiteRating.from_description(description)
  end
end
