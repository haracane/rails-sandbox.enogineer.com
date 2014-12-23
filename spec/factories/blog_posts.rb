# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog_post, class: 'Blog::Post' do
    site { create(:blog_site) }
    sequence(:permalink) { |n| "permalink_#{n}" }
    title 'title'
    content 'content'
  end
end
