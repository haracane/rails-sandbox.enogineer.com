class CreateBlogSites < ActiveRecord::Migration
  def change
    create_table :blog_sites do |t|
      t.references :user, index: true, null: false
      t.string :language, null: false, limit: 2
      t.string :title, null: false, limit: 128
      t.text :description, null: false

      t.timestamps
    end

    add_index :blog_sites, [:user_id, :title], unique: true

    add_foreign_key :blog_sites, :users
  end
end
