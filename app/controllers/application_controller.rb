class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    head :not_found
  end
end
