module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class PasswordMismatch < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :record_invalid
    rescue_from ExceptionHandler::InvalidToken, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ExceptionHandler::PasswordMismatch, with: :password_not_matching_confirmation
  end

  def record_invalid(error)
    json_response(status: :unprocessable_entity, message: error.message)
  end

  def unauthorized_request(error)
    json_response(status: :unathorized, message: error.message)
  end

  def record_not_found(error)
    json_response(status: :not_found, message: error.message)
  end

  def password_not_matching_confirmation(error)
    json_response(status: :unprocessable_entity, message: error.message)
  end
end
