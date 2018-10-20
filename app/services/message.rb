class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.document_created
    'Document created successfully'
  end

  def self.document_updated
    'Document updated successfully'
  end

  def self.document_deleted
    'Document deleted successfully'
  end

  def self.user_deleted
    'Account deleted successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end

  def self.password_mismatch
    "Password and password confirmation don't match"
  end

  def self.admin_required
    "Oops... you must be an admin to perform this action"
  end

  def self.account_updated
    'Account updated successfully'
  end

  def self.access_not_granted
    'Sorry, you are not authorized to perform this action'
  end

  def self.successful_signin
    'Successfully signed in'
  end
end
