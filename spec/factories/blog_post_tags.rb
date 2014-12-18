FactoryGirl.define do
  factory :blog_post_tag, class: 'Blog::PostTag' do
    post { create(:blog_post) }
    tag { create(:blog_tag) }
  end
end
