require 'rails_helper'

describe Blog::Post, type: :model do
  subject { build(:blog_post) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times }
  end

  context 'with associations' do
    it { should belong_to(:site) }
    it { should have_many(:post_tags) }
    it { should have_many(:tags).through(:post_tags) }
  end

  context 'with validations' do
    it { should validate_presence_of(:site_id) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }

    it { should ensure_length_of(:permalink).is_at_most(64) }
    it { should ensure_length_of(:title).is_at_most(128) }

    it { should safely_validate_uniqueness_of(:permalink) }

    it do
      should validate_objects_length_of(:post_tags).
               is_at_most(Blog::Post::MAX_POST_TAGS_LENGTH).
               with_message("タグは#{Blog::Post::MAX_POST_TAGS_LENGTH}個までしか登録できません")
    end
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:site_id) }
    it { should have_not_null_constraint_on(:permalink) }
    it { should have_not_null_constraint_on(:title) }
    it { should have_not_null_constraint_on(:content) }

    it { should have_unique_constraint_on(:permalink) }

    it { should have_foreign_key_constraint_on(:site_id) }
  end
end
