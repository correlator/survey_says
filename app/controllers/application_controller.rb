class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: 'gemos', password: 'ConnectedData'

  def render_404
    head :not_found
  end

  def json_400(object)
    {
      json: object.errors,
      status: :unprocessable_entity
    }
  end
end
