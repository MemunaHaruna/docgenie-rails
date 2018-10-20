class ApplicationController < ActionController::API
  include ::ActionController::Serialization
  include Response
  include ExceptionHandler
  include AuthChecker

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
end
