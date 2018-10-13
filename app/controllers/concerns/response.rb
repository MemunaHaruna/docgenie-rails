module Response
  def json_response(message: 'success', status: :ok, object: nil)
    render json: { data: object, message: message}, status: status
  end
end
