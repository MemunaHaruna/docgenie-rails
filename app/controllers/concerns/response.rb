# frozen_string_literal: true

module Response
  def json_response(
    message: "success",
    status: :ok,
    object: nil,
    show_children: true
  )
    if object.respond_to? :size
      render json: object, show_children: show_children,
             meta: {
               message: message,
               pagination: pagination_dict(object)
             }, status: status
    else
      render json: object, show_children: show_children,
             meta: message, meta_key: :message, status: status
    end
  end

  def json_error_response(message: "error", status: :unprocessable_entity)
    render json: { message: message }, status: status
  end

  def json_response_default(message: "success", status: :ok)
    render json: { message: message }, status: status
  end

  def json_response_auth(message: "success", status: :ok, object: nil)
    render json: { token: object, message: message }, status: status
  end
end
