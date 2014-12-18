FactoryGirl.define do
  factory :blog_site_config, class: 'Blog::SiteConfig' do
    site { create(:blog_site) }
    redirect_to 'MyString'
  end
end
