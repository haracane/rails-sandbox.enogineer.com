# app/assets/javascripts/blog/sites/index.coffee
$ ->
  $('body#blog-sites-index-page').each ->
    $('button.redirect-to-edit').click ->
      showBlogSiteConfigForm($(@).data('blog-site-id'))

    showBlogSiteConfigForm = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-edit").slideDown()
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-show").slideUp()

    hideBlogSiteConfigForm = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-edit").slideUp()
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-show").slideDown()

    $('button.redirect-to-save').click ->
      createOrUpdateBlogSiteConfig($(@).data('blog-site-id'))

    createOrUpdateBlogSiteConfig = (blogSiteId) ->
      id = blogSiteConfigIdOf(blogSiteId)

      if id
        url = "/blog/site_configs/#{id}/"
        method = 'PUT'
      else
        url = '/blog/site_configs/'
        method = 'POST'

      $.ajax url,
        type: method,
        data:
          site_config: blogSiteConfigParams(blogSiteId)
        dataType: 'json'
        success: (data) ->
          receiveBlogSiteConfig(blogSiteId, data)
          hideBlogSiteConfigForm(blogSiteId)

    blogSiteConfigIdOf = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} td.blog-site-config").data('id')

    blogSiteConfigParams = (blogSiteId) ->
      site_id: blogSiteId,
      redirect_to: $("tr#blog-site-#{blogSiteId} input.redirect-to-input").val()

    receiveBlogSiteConfig = (blogSiteId, data) ->
      $("tr#blog-site-#{blogSiteId} td.blog-site-config").data('id', data['id'])
      $("tr#blog-site-#{blogSiteId} p.redirect-to-show").text(data['redirect_to'])
      $("tr#blog-site-#{blogSiteId} input.redirect-to-input").val(data['redirect_to'])
