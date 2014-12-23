require 'rails_helper'

describe Blog::SiteConfig, type: :model do
  subject { build(:blog_site_config) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times }
  end

  context 'with associations' do
    it { should belong_to(:site) }
  end

  context 'with validations' do
    it { should validate_presence_of(:blog_site_id) }

    it { should ensure_length_of(:redirect_to).is_at_most(255) }

    it { should safely_validate_uniqueness_of(:blog_site_id) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:blog_site_id) }

    it { should have_unique_constraint_on(:blog_site_id) }

    it { should have_foreign_key_constraint_on(:blog_site_id) }
  end
end
