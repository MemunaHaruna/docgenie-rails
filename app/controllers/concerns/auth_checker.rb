# frozen_string_literal: true

module AuthChecker
  def require_admin
    unless current_user&.admin?
      raise ExceptionHandler::UnauthorizedUser,
            Message.admin_required
    end
  end

  def can_update_user(user, user_update_params)
    role = user_update_params[:role]
    first_name = user_update_params[:first_name]
    last_name = user_update_params[:last_name]

    if role.present?
      # admin users can update their first & last name but not their own role
      # admin users can update only the role of other users
      # regular users cannot update their own role or that of other users
      if !first_name.present? && !last_name.present? && !is_current_user?(user)
        require_admin
      elsif first_name.present? || last_name.present? && is_current_user?(user)
        raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
      else
        raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
      end
    else
      raise_error_if_not_current_user(user)
    end
  end

  def raise_error_if_not_current_user(user)
    unless is_current_user?(user)
      raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
    end
  end

  def is_current_user?(user)
    current_user&.id == user.id
  end
end
