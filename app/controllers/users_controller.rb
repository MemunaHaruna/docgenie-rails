class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    verify_password_matches_password_confirmation

    user = User.create!(user_create_params)
    auth_token = Auth::AuthenticateUser.new(user.email, user.password).call
    json_response(status: :created, object: { token: auth_token}, message: Message.account_created)
  end

  def index
    users = User.all
    json_response(object: users)
  end

  private
    def user_create_params
      params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def verify_password_matches_password_confirmation
      return true if user_create_params[:password] == user_create_params[:password_confirmation]

      raise ExceptionHandler::PasswordMismatch, Message.password_mismatch
    end
end
