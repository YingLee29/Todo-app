# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization
  before_action :authenticate_user!

  rescue_from Exception, with: :render500
  rescue_from ActionController::BadRequest, with: :render400
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ActiveRecord::RecordInvalid, with: :render422
  rescue_from Pundit::NotAuthorizedError, with: :render401

  private

  def pundit_user
    CurrentContext.new(current_user, params)
  end

  def render400(exception = nil)
    render_error(400, "Bad Request", exception&.message)
  end

  def render401(exception = nil)
    render_error(401, "Unauthorized", exception&.message)
  end

  def render404(exception = nil)
    render_error(404, "Not Found", exception&.message)
  end

  def render422(exception = nil)
    render_error(422, "Unprocessable Entity", exception&.message)
  end

  def render500(exception = nil)
    render_error(500, "Internal Server Error", exception&.message)
  end

  def render_error(code, message, *error_messages)
    response = {
      message: message,
      errors: error_messages.compact
    }
    render json: response, status: code
  end
end
