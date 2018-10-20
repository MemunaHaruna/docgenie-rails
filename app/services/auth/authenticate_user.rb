# frozen_string_literal: true

module Auth
  class AuthenticateUser
    attr_reader :email, :password

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      Auth::JsonWebToken.encode(user_id: user.id) if user
    end

    def user
      user = User.find_by(email: email)
      return user if user&.authenticate(password)

      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
  end
end
