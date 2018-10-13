class User < ApplicationRecord
  # encrypt password
  has_secure_password

  validates_presence_of :first_name, :last_name, :email, :role, :password_digest
  validates_uniqueness_of :email

  enum role: %w(member admin)
end
