class ApplicationController < ActionController::API
  include ::ActionController::Serialization
  include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user ||= (Auth::AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages
    }
  end

  def require_admin
    raise ExceptionHandler::UnauthorizedUser, Message.admin_required if !current_user&.admin?
  end

  def verify_user_has_correct_requirements(record)
    if current_user&.id != record.user_id
      if record.general?
        require_admin
      else
        raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
      end
    end
  end
end
