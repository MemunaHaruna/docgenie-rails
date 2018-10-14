module Response
  def json_response(message: 'success', status: :ok, object: nil)
    render json: object, meta: message, meta_key: :message, status: status
  end

  def json_error_response(message: 'error', status: :unprocessable_entity)
    render json: { message: message }, status: status
  end

  def json_response_default(message: 'success', status: :ok)
    render json: { message: message }, status: status
  end

  def json_response_auth(message: 'success', status: :ok, object: nil)
    render json: { token: object, message: message }, status: status
  end
end
