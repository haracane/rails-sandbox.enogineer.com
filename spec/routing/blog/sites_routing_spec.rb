require 'rails_helper'

RSpec.describe Blog::SitesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/blog/sites').to route_to('blog/sites#index')
    end

    it 'routes to #new' do
      expect(get: '/blog/sites/new').to route_to('blog/sites#new')
    end

    it 'routes to #show' do
      expect(get: '/blog/sites/1').to route_to('blog/sites#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/blog/sites/1/edit').to route_to('blog/sites#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/blog/sites').to route_to('blog/sites#create')
    end

    it 'routes to #update' do
      expect(put: '/blog/sites/1').to route_to('blog/sites#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/blog/sites/1').to route_to('blog/sites#destroy', id: '1')
    end

  end
end
