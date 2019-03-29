# frozen_string_literal: true

module ErrorHandler # :nodoc:
  extend ActiveSupport::Concern

  STATUS_CODES = {
    VALIDATION_ERROR: 422,
    BAD_REQUEST: 400
  }.freeze

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :validation_error
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

  private

  def validation_error(exception)
    message = exception.try(:message)
    render_exception(STATUS_CODES[:VALIDATION_ERROR], exception, message)
  end

  def bad_request(exception)
    message = exception.try(:message)
    render_exception(STATUS_CODES[:BAD_REQUEST], exception, message)
  end

  def render_exception(code, exception, message)
    render json: {
      errors: [
        {
          code: STATUS_CODES.key(code),
          status: code,
          detail: message
        }
      ]
    }, status: code
  end
end