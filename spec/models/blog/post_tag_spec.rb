require 'rails_helper'

describe Blog::PostTag, type: :model do
  subject { build(:blog_post_tag) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times }
  end

  context 'with associations' do
    it { should belong_to(:post) }
    it { should belong_to(:tag) }
  end

  context 'with validations' do
    it { should validate_presence_of(:blog_post_id) }
    it { should validate_presence_of(:blog_tag_id) }

    it { should safely_validate_uniqueness_of(:blog_post_id, :blog_tag_id) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:blog_post_id) }
    it { should have_not_null_constraint_on(:blog_tag_id) }

    it { should have_unique_constraint_on(:blog_post_id, :blog_tag_id) }

    it { should have_foreign_key_constraint_on(:blog_post_id) }
    it { should have_foreign_key_constraint_on(:blog_tag_id) }
  end
end
