class Blog::Post < ActiveRecord::Base
  include Elasticsearch::Model

  MAX_POST_TAGS_LENGTH = 5

  belongs_to :site
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :site_id, presence: true
  validates :permalink, presence: true, uniqueness: true, length: {maximum: 64}
  validates :title, presence: true, length: {maximum: 128}
  validates :content, presence: true
  validates :post_tags, length: {maximum: MAX_POST_TAGS_LENGTH}
end
