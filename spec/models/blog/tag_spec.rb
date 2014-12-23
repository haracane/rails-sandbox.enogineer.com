require 'rails_helper'

describe Blog::Tag, type: :model do
  subject { build(:blog_tag) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times }
  end

  context 'with associations' do
    it { should have_many(:post_tags) }
  end

  context 'with validations' do
    it { should validate_presence_of(:name) }

    it { should ensure_length_of(:name).is_at_most(255) }

    it { should validate_uniqueness_of(:name) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:name) }

    it { should have_unique_constraint_on(:name) }
  end
end
