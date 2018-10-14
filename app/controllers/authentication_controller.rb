class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token =
    Auth::AuthenticateUser.new(auth_params[:email], auth_params[:password]).call

    json_response_auth(object: auth_token, message: Message.successful_signin)
  end

  private

    def auth_params
      params.permit(:email, :password)
    end
end
