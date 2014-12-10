# app/controllers/blog/site_configs_controller.rb
class Blog::SiteConfigsController < ApplicationController
  before_action :set_site_config, only: [:update]

  def create
    @site_config =
      Blog::SiteConfig.new(site_config_params)
    if @site_config.save
      render json: @site_config
    else
      render json: {message: 'Save Failure'}, status: 400
    end
  end

  def update
    if @site_config.update(site_config_params)
      render json: @site_config
    else
      render json: {message: 'Update Failure'}, status: 400
    end
  end

  private

  def set_site_config
    @site_config = Blog::SiteConfig.find(params[:id])
  end

  def site_config_params
    params.require(:site_config).permit(:site_id, :redirect_to)
  end
end
