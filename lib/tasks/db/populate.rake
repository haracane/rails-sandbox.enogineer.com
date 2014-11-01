desc 'Populate database'
task 'db:populate' => :environment do
  Blog::Post.delete_all
  Blog::Site.delete_all
  User.delete_all

  user = User.create(email: 'haracane@example.com', password: 'password')

  rails_site = FactoryGirl.create(:blog_site, user: user, title: 'Railsブログ', description: 'Railsの技術ブログです')
  FactoryGirl.create(:blog_post, site: rails_site, title: 'ActiveRecord', content: 'ActiveRecordの使い方について')
  FactoryGirl.create(:blog_post, site: rails_site, title: 'RSpec', content: 'RSpecの使い方について')

  elasticsearch_site =
    FactoryGirl.create(
      :blog_site,
      user: user,
      title: 'Elasticsearchブログ',
      description: 'Elasticsearchの技術ブログです'
    )
  FactoryGirl.create(:blog_post, site: elasticsearch_site, title: 'Query', content: 'Queryの使い方')
  FactoryGirl.create(:blog_post, site: elasticsearch_site, title: 'Filter', content: 'Filterの使い方')
end
