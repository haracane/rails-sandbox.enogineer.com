class CreateBlogPostTags < ActiveRecord::Migration
  def change
    create_table :blog_post_tags do |t|
      t.references :blog_post, null: false
      t.references :blog_tag, index: true, null: false
    end

    add_index :blog_post_tags, [:blog_post_id, :blog_tag_id], unique: true

    add_foreign_key :blog_post_tags, :blog_posts
    add_foreign_key :blog_post_tags, :blog_tags
  end
end
