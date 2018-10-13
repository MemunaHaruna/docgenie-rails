class Auth::JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, expiry = 24.hours.from_now)
    payload[:expiry] = expiry.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    result = JWT.decode(token, HMAC_SECRET)[0]

    HashWithIndifferentAccess.new result

  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
