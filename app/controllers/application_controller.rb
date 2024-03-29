class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_host

  def set_host
    @host = request.host
  end

  def after_sign_in_path_for(resource)
    bytes_path
  end
end
