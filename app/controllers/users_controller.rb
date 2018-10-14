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
    json_response_auth(status: :created, object: auth_token, message: Message.account_created)
  end

  def update
    user = set_user
    verify_user_has_required_access(user)
    user.update(user_update_params)
    json_response(status: :ok, object: user, message: Message.account_updated)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def verify_user_has_required_access(user)
      role = user_update_params[:role]
      first_name = user_update_params[:first_name]
      last_name = user_update_params[:last_name]

      if role.present?
        if !first_name.present? && !last_name.present?
          require_admin
        elsif user.admin? && current_user.id == user.id
          return true
        elsif (first_name.present? || last_name.present?)
          raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
        end
      else
        if current_user.id != user.id
          raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
        end
      end
    end

    def user_create_params
      params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def user_update_params
      params.permit(:first_name, :last_name, :role)
    end

    def verify_password_matches_password_confirmation
      return true if user_create_params[:password] == user_create_params[:password_confirmation]

      raise ExceptionHandler::PasswordMismatch, Message.password_mismatch
    end
end
