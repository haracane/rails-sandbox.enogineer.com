require 'rails_helper'

describe Blog::Site, type: :model do
  subject { build(:blog_site) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times } #uniqueなオブジェクトを生成することを確認
  end

  context 'with associations' do
    it { should belong_to(:user) }
    it { should have_one(:site_config) }
    it { should have_many(:posts) }
  end

  context 'with validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }

    it { should ensure_length_of(:title).is_at_most(128) }

    it { should safely_validate_uniqueness_of(:user_id, :title) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:user_id) }
    it { should have_not_null_constraint_on(:title) }
    it { should have_not_null_constraint_on(:description) }

    it { should have_unique_constraint_on(:user_id, :title) }

    it { should have_foreign_key_constraint_on(:user_id) }
  end
end
