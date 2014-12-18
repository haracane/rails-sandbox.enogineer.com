class CreateBlogSiteConfigs < ActiveRecord::Migration
  def change
    create_table :blog_site_configs do |t|
      t.references :site, null: false
      t.string :redirect_to
    end

    add_index :blog_site_configs, :site_id, unique: true

    add_foreign_key :blog_site_configs, :blog_sites, column: :site_id
  end
end
