class CreateBlogSiteConfigs < ActiveRecord::Migration
  def change
    create_table :blog_site_configs do |t|
      t.references :blog_site, null: false
      t.string :redirect_to
    end

    add_index :blog_site_configs, :blog_site_id, unique: true

    add_foreign_key :blog_site_configs, :blog_sites
  end
end
