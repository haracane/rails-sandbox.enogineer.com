class Blog::SitePresenter < ModelPresenter
  delegate :title, :description, to: :object

  def updated_at
    object.updated_at.strftime('%Y年%m月%d日 %H:%M')
  end
end
