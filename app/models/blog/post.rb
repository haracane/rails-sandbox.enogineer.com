class Blog::Post < ActiveRecord::Base
  include Elasticsearch::Model

  belongs_to :site

  validates :site_id, presence: true
  validates :permalink, presence: true, uniqueness: true, length: {maximum: 64}
  validates :title, presence: true, length: {maximum: 128}
  validates :content, presence: true
end
