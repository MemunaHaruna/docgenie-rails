class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :require_admin, only: :index

  def index
    users = User.all
    json_response(object: users)
  end


  def create
    verify_password_matches_password_confirmation

    user = User.create!(user_create_params)
    auth_token = Auth::AuthenticateUser.new(user.email, user.password).call
    json_response(status: :created, object: { token: auth_token}, message: Message.account_created)
  end

  def update
    user = set_user
    verify_user_has_required_access(user)
    user.update(user_update_params)
    json_response(status: :ok, object: { user: user}, message: Message.account_updated)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def verify_user_has_required_access(user)
      role = user_update_params[:role]
      if role.present? && current_user.id != user.id
        require_admin
      end
    end

    def user_create_params
      params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def user_update_params
      params.permit(:first_name, :last_name, :email, :role)
    end

    def verify_password_matches_password_confirmation
      return true if user_create_params[:password] == user_create_params[:password_confirmation]

      raise ExceptionHandler::PasswordMismatch, Message.password_mismatch
    end
end
