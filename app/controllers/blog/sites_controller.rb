class Blog::SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :pundit_auth
  before_action :verify_authorized

  respond_to :html, :xml, :json

  def index
    @sites = policy_scope(Blog::Site)
  end

  def show
    @site_stats = Blog::SiteStatsGenerator.new(@site).generate
  end

  def new
    @site_form = Blog::SiteForm.new
  end

  def edit
    @site_form = Blog::SiteForm.new(site: @site)
  end

  def create
    logging_form = Blog::SiteFormLogger.new(Blog::SiteForm.new(site_params))
    @site_form = logging_form.site_form

    if logging_form.save(current_user)
      @site = @site_form.site
      render :show
    else
      render :new
    end
  end

  def update
    @site.update(site_params)
    respond_with(@site)
  end

  def destroy
    @site.destroy
    respond_with(@site)
  end

  private

  def set_site
    @site = Blog::Site.find(params[:id])
  end

  def site_params
    params.
      require(:blog_site_form).
      permit(:title, :description).
      merge(user: current_user)
  end

  def pundit_record
    @site || controller_path.to_sym
  end
end
