FactoryGirl.define do
  factory :blog_tag, class: 'Blog::Tag' do
    sequence(:name) { |n| "name_#{n}"}
  end

end
