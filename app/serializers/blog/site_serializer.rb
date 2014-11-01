class Blog::SiteSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
end
