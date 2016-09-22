class Api::ApiController < ApplicationController
  def render_api_error(message, status = 400, entity = nil)
    if entity.present?
      message = entity.errors.full_messages.uniq.join(", ")
    end
    render json: {error: true, message: message}, status: status
  end
end