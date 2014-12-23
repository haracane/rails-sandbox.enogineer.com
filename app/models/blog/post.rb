class Blog::Post < ActiveRecord::Base
  include Elasticsearch::Model

  MAX_POST_TAGS_LENGTH = 5

  belongs_to :site, foreign_key: :blog_site_id
  has_many :post_tags, foreign_key: :blog_post_id
  has_many :tags, through: :post_tags

  validates :blog_site_id, presence: true
  validates :permalink, presence: true, uniqueness: true, length: {maximum: 64}
  validates :title, presence: true, length: {maximum: 128}
  validates :content, presence: true
  validates :post_tags, length: {maximum: MAX_POST_TAGS_LENGTH}
end
