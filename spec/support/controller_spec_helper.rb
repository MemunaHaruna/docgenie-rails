module ControllerSpecHelper
  def token_generator(user_id)
    Auth::JsonWebToken.encode(user_id: user_id)
  end

  def expired_token_generator(user_id)
    Auth::JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def valid_headers(user_id)
    {
      "Authorization" => token_generator(user_id),
      "Content-Type" => "application/json"
    }
  end

  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end

  def valid_document_params
    {
      title: 'hello',
      access: 0,
      content: 'random content'
    }
  end

  def invalid_document_params_1
    {
      title: nil,
      access: 0,
      content: 'random content'
    }
  end

  def invalid_document_params_2
    {
      title: 'whatever',
      access: 0,
      content: nil
    }
  end

  def invalid_document_params_3
    {
      title: 'whatever',
      access: nil,
      content: 'toodles'
    }
  end

  def duplicate_document_params
    {
      title: 'hello',
      access: 0,
      content: 'random content'
    }
  end


end
