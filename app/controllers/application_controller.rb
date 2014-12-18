class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def pundit_auth
    authorize(pundit_record)
  rescue Pundit::NotDefinedError
    authorize(:application)
  end

  def pundit_record
    controller_path.to_sym
  end
end
