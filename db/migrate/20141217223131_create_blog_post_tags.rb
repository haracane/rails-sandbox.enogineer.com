class CreateBlogPostTags < ActiveRecord::Migration
  def change
    create_table :blog_post_tags do |t|
      t.references :post, null: false
      t.references :tag, index: true, null: false
    end

    add_index :blog_post_tags, [:post_id, :tag_id], unique: true

    add_foreign_key :blog_post_tags, :blog_posts, column: :post_id
    add_foreign_key :blog_post_tags, :blog_tags, column: :tag_id
  end
end
