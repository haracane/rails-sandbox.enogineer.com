class Blog::Tag < ActiveRecord::Base
  has_many :post_tags, foreign_key: :blog_tag_id

  validates :name, presence: true, uniqueness: true, length: {maximum: 255}
end
