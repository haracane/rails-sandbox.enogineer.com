json.array!(@sites) do |blog_site|
  json.extract! blog_site, :id, :title, :description
  json.url blog_site_url(blog_site, format: :json)
end
