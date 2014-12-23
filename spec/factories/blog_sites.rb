# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog_site, class: 'Blog::Site' do
    user
    sequence(:title) { |n| "title_#{n}" }
    description 'This is a sample blog site.'
  end
end
