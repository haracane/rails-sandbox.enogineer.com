class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.references :site, index: true, null: false
      t.string :permalink, null: false, limit: 64
      t.string :title, null: false, limit: 128
      t.text :content, null: false

      t.timestamps
    end

    add_index :blog_posts, :permalink, unique: true

    add_foreign_key :blog_posts, :blog_sites, column: :site_id
  end
end
