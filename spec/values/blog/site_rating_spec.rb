require 'rails_helper'

describe Blog::SiteRating do
  let(:low_rating) { Blog::SiteRating.from_description('short') }
  let(:high_rating) { Blog::SiteRating.from_description('long description') }
  subject { low_rating }

  it { should_not be_better_than(high_rating) }
  it { should eql(Blog::SiteRating.from_description('short')) }
  its(:to_s) { should eq 'B' }
end
