class Blog::PostTag < ActiveRecord::Base
  belongs_to :post, foreign_key: :blog_post_id
  belongs_to :tag, foreign_key: :blog_tag_id

  validates :blog_post_id, presence: true
  validates :blog_tag_id, presence: true, uniqueness: {scope: :blog_post_id}
end
