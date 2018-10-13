class Auth::AuthorizeApiRequest
  attr_reader :headers

  def initialize(headers = {})
    @headers = headers
  end

  def call
    { user: user }
  end

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken, Message.invalid_token
  end

  def decoded_auth_token
    @decoded_auth_token ||= Auth::JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise ExceptionHandler::MissingToken, Message.missing_token
  end
end
