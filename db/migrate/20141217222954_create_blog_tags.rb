class CreateBlogTags < ActiveRecord::Migration
  def change
    create_table :blog_tags do |t|
      t.string :name, null: false
    end

    add_index :blog_tags, :name, unique: true
  end
end
